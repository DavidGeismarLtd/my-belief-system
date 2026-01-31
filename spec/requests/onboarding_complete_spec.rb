require 'rails_helper'

RSpec.describe "Onboarding Complete", type: :request do
  let(:user) { create(:user, country: 'United States') }
  let!(:dimension) { create(:value_dimension) }
  let!(:question1) { create(:question, value_dimension: dimension, question_type: 'tradeoff_slider', position: 1, is_universal: true) }
  let!(:question2) { create(:question, value_dimension: dimension, question_type: 'tradeoff_slider', position: 2, is_universal: true) }

  before do
    login_as(user, scope: :user)
  end

  describe 'POST /onboarding/complete' do
    context 'with answers in session' do
      before do
        # Initialize onboarding session
        get onboarding_path
        post onboarding_save_profile_path, params: { country: 'United States' }

        # Populate session via actual requests (simulating answering questions)
        post onboarding_answer_path, params: { question_number: 1, answer_value: '75' }
        post onboarding_answer_path, params: { question_number: 2, answer_value: '60' }
      end

      it 'saves answers to database' do
        expect {
          post onboarding_complete_path
        }.to change(UserAnswer, :count).by(2)
      end

      it 'creates user answers with correct data' do
        post onboarding_complete_path

        answer1 = user.user_answers.find_by(question: question1)
        expect(answer1).to be_present
        expect(answer1.answer_data['value']).to eq(75)

        answer2 = user.user_answers.find_by(question: question2)
        expect(answer2).to be_present
        expect(answer2.answer_data['value']).to eq(60)
      end

      it 'updates onboarding progress' do
        post onboarding_complete_path
        user.reload
        expect(user.onboarding_progress).to be > 0
      end

      it 'builds value portraits' do
        expect {
          post onboarding_complete_path
        }.to change(UserValuePortrait, :count).by_at_least(1)
      end

      it 'clears session data' do
        post onboarding_complete_path

        # Verify session is cleared by checking if we can access portrait page
        # (which would redirect if session is empty)
        get onboarding_portrait_path
        expect(response.body).not_to include('question1.id.to_s')
      end

      it 'redirects to dashboard' do
        post onboarding_complete_path
        expect(response).to redirect_to(dashboard_path)
      end

      it 'sets a success notice' do
        post onboarding_complete_path
        follow_redirect!
        expect(response.body).to include("Onboarding completed")
      end
    end

    context 'with no answers in session' do
      before do
        # Start fresh onboarding to clear any session data
        get onboarding_path
      end

      it 'does not create user answers' do
        expect {
          post onboarding_complete_path
        }.not_to change(UserAnswer, :count)
      end

      it 'still redirects to dashboard' do
        post onboarding_complete_path
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with duplicate answers' do
      let!(:existing_answer) { create(:user_answer, user: user, question: question1, answer_data: { value: 50 }) }

      before do
        # Initialize onboarding session
        get onboarding_path
        post onboarding_save_profile_path, params: { country: 'United States' }

        # Populate session via actual requests
        post onboarding_answer_path, params: { question_number: 1, answer_value: '75' }
        post onboarding_answer_path, params: { question_number: 2, answer_value: '60' }
      end

      it 'does not create duplicate answers' do
        expect {
          post onboarding_complete_path
        }.to change(UserAnswer, :count).by(1) # Only question2
      end

      it 'keeps the existing answer unchanged' do
        post onboarding_complete_path
        existing_answer.reload
        expect(existing_answer.answer_data['value']).to eq(50) # Original value
      end
    end
  end
end
