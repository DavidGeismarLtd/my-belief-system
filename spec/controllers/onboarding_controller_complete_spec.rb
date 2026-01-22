require 'rails_helper'

RSpec.describe OnboardingController, type: :controller do
  let(:user) { create(:user) }
  let!(:dimension) { create(:value_dimension) }
  let!(:question1) { create(:question, value_dimension: dimension, question_type: 'tradeoff_slider') }
  let!(:question2) { create(:question, value_dimension: dimension, question_type: 'tradeoff_slider') }
  
  before do
    sign_in user
  end

  describe 'POST #complete' do
    context 'with answers in session' do
      before do
        session[:answers] = {
          question1.id.to_s => 75,
          question2.id.to_s => 60
        }
      end

      it 'saves answers to database' do
        expect {
          post :complete
        }.to change(UserAnswer, :count).by(2)
      end

      it 'creates user answers with correct data' do
        post :complete
        
        answer1 = user.user_answers.find_by(question: question1)
        expect(answer1).to be_present
        expect(answer1.answer_data['value']).to eq(75)
        
        answer2 = user.user_answers.find_by(question: question2)
        expect(answer2).to be_present
        expect(answer2.answer_data['value']).to eq(60)
      end

      it 'updates onboarding progress' do
        post :complete
        user.reload
        expect(user.onboarding_progress).to be > 0
      end

      it 'builds value portraits' do
        expect {
          post :complete
        }.to change(UserValuePortrait, :count).by_at_least(1)
      end

      it 'clears session data' do
        post :complete
        expect(session[:answers]).to eq({})
        expect(session[:user_profile]).to eq({})
      end

      it 'redirects to dashboard' do
        post :complete
        expect(response).to redirect_to(dashboard_path)
      end

      it 'sets a success notice' do
        post :complete
        expect(flash[:notice]).to include("Onboarding completed")
      end
    end

    context 'with no answers in session' do
      before do
        session[:answers] = {}
      end

      it 'does not create user answers' do
        expect {
          post :complete
        }.not_to change(UserAnswer, :count)
      end

      it 'still redirects to dashboard' do
        post :complete
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with duplicate answers' do
      let!(:existing_answer) { create(:user_answer, user: user, question: question1, answer_data: { value: 50 }) }

      before do
        session[:answers] = {
          question1.id.to_s => 75,
          question2.id.to_s => 60
        }
      end

      it 'does not create duplicate answers' do
        expect {
          post :complete
        }.to change(UserAnswer, :count).by(1) # Only question2
      end

      it 'keeps the existing answer unchanged' do
        post :complete
        existing_answer.reload
        expect(existing_answer.answer_data['value']).to eq(50) # Original value
      end
    end
  end
end

