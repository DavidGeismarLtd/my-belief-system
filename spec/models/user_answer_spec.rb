require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    subject { build(:user_answer) }

    it { should validate_presence_of(:answer_data) }

    it 'validates uniqueness of user_id scoped to question_id' do
      user = create(:user)
      question = create(:question)
      create(:user_answer, user: user, question: question)

      duplicate = build(:user_answer, user: user, question: question)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include('has already answered this question')
    end

    describe 'answer_data_has_value validation' do
      it 'is invalid when answer_data is blank' do
        answer = build(:user_answer, answer_data: nil)
        expect(answer).not_to be_valid
        expect(answer.errors[:answer_data]).to include("must contain a 'value' key")
      end

      it 'is invalid when answer_data does not have a value key' do
        answer = build(:user_answer, answer_data: { time_spent: 10 })
        expect(answer).not_to be_valid
        expect(answer.errors[:answer_data]).to include("must contain a 'value' key")
      end

      it 'is valid when answer_data has a value key' do
        answer = build(:user_answer, answer_data: { value: 3 })
        expect(answer).to be_valid
      end
    end

    describe 'answer_value_is_valid validation' do
      context 'for direct_value questions' do
        let(:question) { create(:question, question_type: 'direct_value') }

        it 'is valid for values 1-5' do
          (1..5).each do |value|
            answer = build(:user_answer, question: question, answer_data: { value: value })
            expect(answer).to be_valid
          end
        end

        it 'is invalid for values outside 1-5' do
          answer = build(:user_answer, question: question, answer_data: { value: 10 })
          expect(answer).not_to be_valid
          expect(answer.errors[:answer_data]).to be_present
        end

        it 'is invalid for non-integer values' do
          answer = build(:user_answer, question: question, answer_data: { value: 'three' })
          expect(answer).not_to be_valid
        end
      end

      context 'for policy_preference questions' do
        let(:question) { create(:question, question_type: 'policy_preference') }

        it 'is valid for "left" or "right"' do
          answer = build(:user_answer, question: question, answer_data: { value: 'left' })
          expect(answer).to be_valid

          answer.answer_data = { value: 'right' }
          expect(answer).to be_valid
        end

        it 'is invalid for other values' do
          answer = build(:user_answer, question: question, answer_data: { value: 'center' })
          expect(answer).not_to be_valid
        end
      end

      context 'for tradeoff_slider questions' do
        let(:question) { create(:question, question_type: 'tradeoff_slider') }

        it 'is valid for values 0-100' do
          [ 0, 50, 100 ].each do |value|
            answer = build(:user_answer, question: question, answer_data: { value: value })
            expect(answer).to be_valid
          end
        end

        it 'is invalid for values outside 0-100' do
          answer = build(:user_answer, question: question, answer_data: { value: 150 })
          expect(answer).not_to be_valid
        end
      end

      context 'for dilemma questions' do
        let(:question) { create(:question, question_type: 'dilemma') }

        it 'is valid for "A" or "B"' do
          answer = build(:user_answer, question: question, answer_data: { value: 'A' })
          expect(answer).to be_valid

          answer.answer_data = { value: 'B' }
          expect(answer).to be_valid
        end

        it 'is invalid for other values' do
          answer = build(:user_answer, question: question, answer_data: { value: 'C' })
          expect(answer).not_to be_valid
        end
      end
    end
  end

  describe 'callbacks' do
    it 'updates user onboarding progress after create' do
      user = create(:user, onboarding_progress: 0)
      questions = create_list(:question, 10)

      # Calculate expected progress: 1 answer / total active questions * 100
      total_questions = Question.active.count
      expected_progress = ((1.0 / total_questions) * 100).round

      expect {
        create(:user_answer, user: user, question: questions.first)
      }.to change { user.reload.onboarding_progress }.from(0).to(expected_progress)
    end
  end

  describe 'scopes' do
    let!(:old_answer) { create(:user_answer) }
    let!(:new_answer) { create(:user_answer) }
    let(:dimension) { create(:value_dimension) }
    let(:question_in_dimension) { create(:question, value_dimension: dimension) }
    let!(:answer_in_dimension) { create(:user_answer, question: question_in_dimension) }

    describe '.recent' do
      it 'returns answers ordered by created_at desc' do
        answers = UserAnswer.recent.to_a
        expect(answers.first.created_at).to be >= answers.last.created_at
      end
    end

    describe '.for_dimension' do
      it 'returns answers for questions in specified dimension' do
        expect(UserAnswer.for_dimension(dimension.id)).to include(answer_in_dimension)
        expect(UserAnswer.for_dimension(dimension.id)).not_to include(old_answer, new_answer)
      end
    end

    describe '.by_question_type' do
      let(:direct_question) { create(:question, question_type: 'direct_value') }
      let!(:direct_answer) { create(:user_answer, question: direct_question) }

      it 'returns answers for questions of specified type' do
        expect(UserAnswer.by_question_type('direct_value')).to include(direct_answer)
      end
    end
  end

  describe '#value' do
    it 'returns the value from answer_data' do
      answer = build(:user_answer, answer_data: { value: 4 })
      expect(answer.value).to eq(4)
    end
  end

  describe '#time_spent' do
    it 'returns the time_spent_seconds from answer_data' do
      answer = build(:user_answer, answer_data: { value: 4, time_spent_seconds: 25 })
      expect(answer.time_spent).to eq(25)
    end
  end

  describe '#normalized_value' do
    context 'for direct_value questions (scale 1-5)' do
      let(:question) { create(:question, question_type: 'direct_value') }

      it 'normalizes to -100 to 100 scale' do
        answer = build(:user_answer, question: question, answer_data: { value: 1 })
        expect(answer.normalized_value).to eq(-100.0)

        answer.answer_data = { value: 3 }
        expect(answer.normalized_value).to eq(0.0)

        answer.answer_data = { value: 5 }
        expect(answer.normalized_value).to eq(100.0)
      end
    end

    context 'for policy_preference questions' do
      let(:question) { create(:question, question_type: 'policy_preference') }

      it 'returns -100 for left, 100 for right' do
        answer = build(:user_answer, question: question, answer_data: { value: 'left' })
        expect(answer.normalized_value).to eq(-100)

        answer.answer_data = { value: 'right' }
        expect(answer.normalized_value).to eq(100)
      end
    end

    context 'for tradeoff_slider questions (scale 0-100)' do
      let(:question) { create(:question, question_type: 'tradeoff_slider') }

      it 'normalizes to -100 to 100 scale' do
        answer = build(:user_answer, question: question, answer_data: { value: 0 })
        expect(answer.normalized_value).to eq(-100.0)

        answer.answer_data = { value: 50 }
        expect(answer.normalized_value).to eq(0.0)

        answer.answer_data = { value: 100 }
        expect(answer.normalized_value).to eq(100.0)
      end
    end

    context 'for dilemma questions' do
      let(:question) { create(:question, question_type: 'dilemma') }

      it 'returns -100 for A, 100 for B' do
        answer = build(:user_answer, question: question, answer_data: { value: 'A' })
        expect(answer.normalized_value).to eq(-100)

        answer.answer_data = { value: 'B' }
        expect(answer.normalized_value).to eq(100)
      end
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      user = create(:user, email: 'test@example.com')
      question = create(:question)
      answer = create(:user_answer, user: user, question: question, answer_data: { value: 4 })

      expect(answer.to_s).to include('test@example.com')
      expect(answer.to_s).to include("Q#{question.id}")
      expect(answer.to_s).to include('4')
    end
  end
end
