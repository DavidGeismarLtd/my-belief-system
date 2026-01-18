require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:value_dimension) }
    it { should have_many(:user_answers).dependent(:destroy) }
    it { should have_many(:users).through(:user_answers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:question_type) }
    it { should validate_inclusion_of(:question_type).in_array(Question::QUESTION_TYPES) }
    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).only_integer }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:difficulty_score).only_integer }
    it { should validate_numericality_of(:difficulty_score).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:difficulty_score).is_less_than_or_equal_to(5) }
  end

  describe 'scopes' do
    let(:dimension) { create(:value_dimension) }
    let!(:active_question) { create(:question, active: true, position: 1, difficulty_score: 1) }
    let!(:inactive_question) { create(:question, active: false, position: 2, difficulty_score: 3) }
    let!(:hard_question) { create(:question, active: true, position: 3, difficulty_score: 5) }
    let!(:direct_value_question) { create(:question, question_type: 'direct_value') }
    let!(:dilemma_question) { create(:question, question_type: 'dilemma') }

    describe '.active' do
      it 'returns only active questions' do
        expect(Question.active).to include(active_question, hard_question)
        expect(Question.active).not_to include(inactive_question)
      end
    end

    describe '.ordered' do
      it 'returns questions ordered by position' do
        expect(Question.ordered.first).to eq(active_question)
      end
    end

    describe '.by_type' do
      it 'returns questions of specified type' do
        expect(Question.by_type('direct_value')).to include(direct_value_question)
        expect(Question.by_type('direct_value')).not_to include(dilemma_question)
      end
    end

    describe '.for_dimension' do
      it 'returns questions for specified dimension' do
        dim_question = create(:question, value_dimension: dimension)
        expect(Question.for_dimension(dimension.id)).to include(dim_question)
      end
    end

    describe '.easy' do
      it 'returns questions with difficulty_score 1-2' do
        expect(Question.easy).to include(active_question)
        expect(Question.easy).not_to include(inactive_question, hard_question)
      end
    end

    describe '.medium' do
      it 'returns questions with difficulty_score 3' do
        expect(Question.medium).to include(inactive_question)
        expect(Question.medium).not_to include(active_question, hard_question)
      end
    end

    describe '.hard' do
      it 'returns questions with difficulty_score 4-5' do
        expect(Question.hard).to include(hard_question)
        expect(Question.hard).not_to include(active_question, inactive_question)
      end
    end
  end

  describe '#answer_count' do
    let(:question) { create(:question) }

    it 'returns the number of answers' do
      create_list(:user_answer, 3, question: question)
      expect(question.answer_count).to eq(3)
    end
  end

  describe '#average_answer_value' do
    let(:question) { create(:question, question_type: 'direct_value') }

    context 'when there are answers' do
      it 'returns the average value' do
        create(:user_answer, question: question, answer_data: { value: 2 })
        create(:user_answer, question: question, answer_data: { value: 4 })
        create(:user_answer, question: question, answer_data: { value: 3 })

        expect(question.average_answer_value).to eq(3.0)
      end
    end

    context 'when there are no answers' do
      it 'returns nil' do
        expect(question.average_answer_value).to be_nil
      end
    end

    context 'when answers have no value' do
      it 'returns nil' do
        # For direct_value questions, we need a valid value, so let's test with a different question type
        question_without_value = create(:question, question_type: 'tradeoff_slider')
        create(:user_answer, question: question_without_value, answer_data: { left_value: 50, right_value: 50 })
        expect(question_without_value.average_answer_value).to be_nil
      end
    end
  end

  describe '#difficulty_label' do
    it 'returns "easy" for difficulty_score 1-2' do
      question = build(:question, difficulty_score: 1)
      expect(question.difficulty_label).to eq('easy')

      question.difficulty_score = 2
      expect(question.difficulty_label).to eq('easy')
    end

    it 'returns "medium" for difficulty_score 3' do
      question = build(:question, difficulty_score: 3)
      expect(question.difficulty_label).to eq('medium')
    end

    it 'returns "hard" for difficulty_score 4-5' do
      question = build(:question, difficulty_score: 4)
      expect(question.difficulty_label).to eq('hard')

      question.difficulty_score = 5
      expect(question.difficulty_label).to eq('hard')
    end
  end

  describe 'question type predicates' do
    it '#direct_value? returns true for direct_value questions' do
      question = build(:question, question_type: 'direct_value')
      expect(question.direct_value?).to be true
      expect(question.policy_preference?).to be false
    end

    it '#policy_preference? returns true for policy_preference questions' do
      question = build(:question, question_type: 'policy_preference')
      expect(question.policy_preference?).to be true
      expect(question.direct_value?).to be false
    end

    it '#tradeoff_slider? returns true for tradeoff_slider questions' do
      question = build(:question, question_type: 'tradeoff_slider')
      expect(question.tradeoff_slider?).to be true
      expect(question.dilemma?).to be false
    end

    it '#dilemma? returns true for dilemma questions' do
      question = build(:question, question_type: 'dilemma')
      expect(question.dilemma?).to be true
      expect(question.tradeoff_slider?).to be false
    end
  end

  describe '#to_s' do
    it 'returns truncated text' do
      long_text = 'a' * 100
      question = build(:question, text: long_text)
      expect(question.to_s.length).to be <= 50
    end
  end
end
