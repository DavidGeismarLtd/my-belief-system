require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_answers).dependent(:destroy) }
    it { should have_many(:answered_questions).through(:user_answers).source(:question) }
    it { should have_many(:user_value_portraits).dependent(:destroy) }
    it { should have_many(:value_dimensions).through(:user_value_portraits) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_numericality_of(:onboarding_progress).only_integer }
    it { should validate_numericality_of(:onboarding_progress).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:onboarding_progress).is_less_than_or_equal_to(100) }
  end

  describe 'callbacks' do
    it 'downcases email before save' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'scopes' do
    let!(:completed_user) { create(:user, onboarding_completed: true) }
    let!(:incomplete_user) { create(:user, onboarding_completed: false) }
    let!(:old_user) { create(:user) }
    let!(:new_user) { create(:user) }

    describe '.onboarding_completed' do
      it 'returns only users who completed onboarding' do
        expect(User.onboarding_completed).to include(completed_user)
        expect(User.onboarding_completed).not_to include(incomplete_user)
      end
    end

    describe '.onboarding_incomplete' do
      it 'returns only users who have not completed onboarding' do
        expect(User.onboarding_incomplete).to include(incomplete_user)
        expect(User.onboarding_incomplete).not_to include(completed_user)
      end
    end

    describe '.recent' do
      it 'returns users ordered by created_at desc' do
        users = User.recent.to_a
        expect(users.first.created_at).to be >= users.last.created_at
      end
    end
  end

  describe '#portrait_complete?' do
    let(:user) { create(:user) }
    let!(:dimensions) { create_list(:value_dimension, 3) }

    context 'when user has portraits for all active dimensions' do
      before do
        dimensions.each do |dim|
          create(:user_value_portrait, user: user, value_dimension: dim)
        end
      end

      it 'returns true' do
        expect(user.portrait_complete?).to be true
      end
    end

    context 'when user has fewer portraits than active dimensions' do
      before do
        create(:user_value_portrait, user: user, value_dimension: dimensions.first)
      end

      it 'returns false' do
        expect(user.portrait_complete?).to be false
      end
    end
  end

  describe '#answered_question_count' do
    let(:user) { create(:user) }

    it 'returns the number of answered questions' do
      create_list(:user_answer, 3, user: user)
      expect(user.answered_question_count).to eq(3)
    end
  end

  describe '#skipped_question_count' do
    let(:user) { create(:user, skipped_questions: [1, 2, 3]) }

    it 'returns the number of skipped questions' do
      expect(user.skipped_question_count).to eq(3)
    end

    it 'returns 0 when skipped_questions is nil' do
      user.skipped_questions = nil
      expect(user.skipped_question_count).to eq(0)
    end
  end

  describe '#can_skip_question?' do
    let(:user) { create(:user) }

    it 'returns true when user has skipped fewer than 3 questions' do
      user.skipped_questions = [1, 2]
      expect(user.can_skip_question?).to be true
    end

    it 'returns false when user has skipped 3 or more questions' do
      user.skipped_questions = [1, 2, 3]
      expect(user.can_skip_question?).to be false
    end
  end

  describe '#skip_question!' do
    let(:user) { create(:user) }

    context 'when user can skip questions' do
      it 'adds question_id to skipped_questions' do
        expect { user.skip_question!(5) }.to change { user.skipped_question_count }.by(1)
        expect(user.skipped_questions).to include(5)
      end

      it 'does not add duplicate question_ids' do
        user.skip_question!(5)
        expect { user.skip_question!(5) }.not_to change { user.skipped_question_count }
      end
    end

    context 'when user cannot skip more questions' do
      before { user.update(skipped_questions: [1, 2, 3]) }

      it 'returns false and does not add question' do
        expect(user.skip_question!(4)).to be false
        expect(user.skipped_questions).not_to include(4)
      end
    end
  end

  describe '#update_onboarding_progress!' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 10) }

    it 'updates onboarding_progress based on answered questions' do
      # Create 5 answers for the user
      questions.first(5).each do |question|
        create(:user_answer, user: user, question: question)
      end

      user.update_onboarding_progress!

      # Calculate expected progress: 5 answers / total active questions * 100
      total_questions = Question.active.count
      expected_progress = ((5.0 / total_questions) * 100).round

      expect(user.onboarding_progress).to eq(expected_progress)
    end

    it 'marks onboarding as completed when progress reaches 100%' do
      questions.each do |question|
        create(:user_answer, user: user, question: question)
      end
      user.update_onboarding_progress!
      expect(user.onboarding_completed).to be true
    end
  end
end
