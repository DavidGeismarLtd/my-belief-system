require 'rails_helper'

RSpec.describe OnboardingController, type: :controller do
  render_views
  describe 'GET #start' do
    it 'resets session answers and user_profile' do
      session[:answers] = { '1' => 'old_answer' }
      session[:user_profile] = { country: 'Old Country' }

      get :start

      expect(session[:answers]).to eq({})
      expect(session[:user_profile]).to eq({})
      expect(response).to have_http_status(:success)
    end

    it 'renders the start template' do
      get :start
      expect(response).to render_template(:start)
    end
  end

  describe 'POST #save_profile' do
    let(:profile_params) do
      {
        country: 'United States',
        age: '30',
        gender: 'Male',
        political_engagement: 'Very engaged'
      }
    end

    it 'saves profile data to session' do
      post :save_profile, params: profile_params

      expect(session[:user_profile][:country]).to eq('United States')
      expect(session[:user_profile][:age]).to eq('30')
      expect(session[:user_profile][:gender]).to eq('Male')
      expect(session[:user_profile][:political_engagement]).to eq('Very engaged')
    end

    it 'redirects to first question' do
      post :save_profile, params: profile_params
      expect(response).to redirect_to(onboarding_question_path(1))
    end
  end

  describe 'GET #question' do
    let(:dimension) { create(:value_dimension) }
    let!(:universal_question) { create(:question, value_dimension: dimension, position: 1, is_universal: true) }
    let!(:us_question) { create(:question, value_dimension: dimension, position: 2, country: 'United States', is_universal: false) }

    context 'without country in session' do
      it 'loads only universal questions' do
        get :question, params: { number: 1 }

        expect(assigns(:questions)).to include(universal_question)
        expect(assigns(:questions)).not_to include(us_question)
      end
    end

    context 'with country in session' do
      before do
        session[:user_profile] = { country: 'United States' }
      end

      it 'loads universal and country-specific questions' do
        get :question, params: { number: 1 }

        expect(assigns(:questions)).to include(universal_question, us_question)
      end

      it 'assigns the correct question based on number' do
        get :question, params: { number: 1 }

        expect(assigns(:question)).to eq(universal_question)
      end

      it 'assigns total questions count' do
        get :question, params: { number: 1 }

        expect(assigns(:total_questions)).to eq(2)
      end
    end

    context 'when question number exceeds total' do
      before do
        session[:user_profile] = { country: 'United States' }
      end

      it 'redirects to portrait page' do
        get :question, params: { number: 999 }

        expect(response).to redirect_to(onboarding_portrait_path)
      end
    end

    it 'renders the question template' do
      get :question, params: { number: 1 }
      expect(response).to render_template(:question)
    end

    describe 'question type rendering' do
      before do
        session[:user_profile] = { country: 'United States' }
        # Clear existing questions to ensure we're testing the right one
        Question.destroy_all
      end

      it 'renders direct_value questions with 1-5 scale buttons' do
        question = create(:question, question_type: 'direct_value', value_dimension: dimension, position: 1, is_universal: true)
        get :question, params: { number: 1 }

        expect(response).to have_http_status(:success)
        expect(assigns(:question)).to eq(question)
        expect(response.body).to include('Strongly Disagree')
        expect(response.body).to include('Strongly Agree')
        expect(response.body).to include('data-answer-value="1"')
        expect(response.body).to include('data-answer-value="5"')
        expect(response.body).to include('id="next-button"')
        expect(response.body).to include('disabled')
      end

      it 'renders policy_preference questions with left/right buttons' do
        question = create(:question, question_type: 'policy_preference', value_dimension: dimension, position: 1, is_universal: true,
                          options: { left_option: 'More regulation', right_option: 'Less regulation' })
        get :question, params: { number: 1 }

        expect(response.body).to include('Left Position')
        expect(response.body).to include('Right Position')
        expect(response.body).to include('data-answer-value="left"')
        expect(response.body).to include('data-answer-value="right"')
        expect(response.body).to include('More regulation')
        expect(response.body).to include('Less regulation')
        expect(response.body).to include('id="next-button"')
      end

      it 'renders tradeoff_slider questions with slider input' do
        question = create(:question, question_type: 'tradeoff_slider', value_dimension: dimension, position: 1, is_universal: true,
                          options: { left_option: 'Security', right_option: 'Privacy' })
        get :question, params: { number: 1 }

        expect(response.body).to include('type="range"')
        expect(response.body).to include('min="0"')
        expect(response.body).to include('max="100"')
        expect(response.body).to include('Security')
        expect(response.body).to include('Privacy')
      end

      it 'renders dilemma questions with A/B choice buttons' do
        question = create(:question, question_type: 'dilemma', value_dimension: dimension, position: 1, is_universal: true,
                          options: { option_a: 'Choice A description', option_b: 'Choice B description' })
        get :question, params: { number: 1 }

        expect(response.body).to include('Option A')
        expect(response.body).to include('Option B')
        expect(response.body).to include('data-answer-value="A"')
        expect(response.body).to include('data-answer-value="B"')
        expect(response.body).to include('Choice A description')
        expect(response.body).to include('Choice B description')
        expect(response.body).to include('id="next-button"')
      end
    end

    describe 'answer persistence' do
      before do
        session[:user_profile] = { country: 'United States' }
        Question.destroy_all
      end

      it 'shows previously selected answer when navigating back to a direct_value question' do
        question = create(:question, question_type: 'direct_value', value_dimension: dimension, position: 1, is_universal: true)
        session[:answers] = { question.id.to_s => '4' }

        get :question, params: { number: 1 }

        expect(response.body).to include('border-blue-600 bg-blue-50')
        expect(response.body).to include('value="4"')
        expect(response.body).to include('bg-blue-600 text-white')
        expect(response.body).not_to match(/id="next-button"[^>]*disabled/)
      end

      it 'shows previously selected answer when navigating back to a policy_preference question' do
        question = create(:question, question_type: 'policy_preference', value_dimension: dimension, position: 1, is_universal: true,
                          options: { left_option: 'More regulation', right_option: 'Less regulation' })
        session[:answers] = { question.id.to_s => 'left' }

        get :question, params: { number: 1 }

        expect(response.body).to include('border-blue-600 bg-blue-50')
        expect(response.body).to include('value="left"')
      end

      it 'shows previously selected answer when navigating back to a tradeoff_slider question' do
        question = create(:question, question_type: 'tradeoff_slider', value_dimension: dimension, position: 1, is_universal: true,
                          options: { left_option: 'Security', right_option: 'Privacy' })
        session[:answers] = { question.id.to_s => '75' }

        get :question, params: { number: 1 }

        expect(response.body).to include('value="75"')
        expect(response.body).to include('>75</span>')
      end

      it 'shows previously selected answer when navigating back to a dilemma question' do
        question = create(:question, question_type: 'dilemma', value_dimension: dimension, position: 1, is_universal: true,
                          options: { option_a: 'Choice A', option_b: 'Choice B' })
        session[:answers] = { question.id.to_s => 'B' }

        get :question, params: { number: 1 }

        expect(response.body).to include('border-blue-600 bg-blue-50')
        expect(response.body).to include('value="B"')
      end
    end
  end

  describe 'POST #answer' do
    let(:dimension) { create(:value_dimension) }
    let!(:question1) { create(:question, value_dimension: dimension, position: 1, is_universal: true) }
    let!(:question2) { create(:question, value_dimension: dimension, position: 2, is_universal: true) }

    before do
      session[:user_profile] = { country: 'United States' }
    end

    it 'stores answer in session' do
      post :answer, params: { question_number: 1, answer_value: '75' }

      expect(session[:answers][question1.id.to_s]).to eq('75')
    end

    context 'when not the last question' do
      it 'redirects to next question' do
        post :answer, params: { question_number: 1, answer_value: '75' }

        expect(response).to redirect_to(onboarding_question_path(2))
      end
    end

    context 'when last question' do
      it 'redirects to portrait page' do
        post :answer, params: { question_number: 2, answer_value: '75' }

        expect(response).to redirect_to(onboarding_portrait_path)
      end
    end

    it 'handles multiple answers in sequence' do
      post :answer, params: { question_number: 1, answer_value: '50' }
      post :answer, params: { question_number: 2, answer_value: '75' }

      expect(session[:answers][question1.id.to_s]).to eq('50')
      expect(session[:answers][question2.id.to_s]).to eq('75')
    end
  end

  describe 'GET #portrait' do
    let(:dimension1) { create(:value_dimension, name: 'Liberty vs Authority') }
    let(:dimension2) { create(:value_dimension, name: 'Economic Equality') }
    let!(:question1) { create(:question, value_dimension: dimension1, position: 1, is_universal: true) }
    let!(:question2) { create(:question, value_dimension: dimension2, position: 2, is_universal: true) }

    before do
      session[:user_profile] = { country: 'United States' }
      session[:answers] = {
        question1.id.to_s => '75',
        question2.id.to_s => '25'
      }
    end

    it 'calculates portrait from session answers' do
      get :portrait

      expect(assigns(:portrait)).to be_present
      expect(assigns(:portrait)[:dimensions]).to be_an(Array)
    end

    it 'includes all active dimensions in portrait' do
      get :portrait

      dimension_names = assigns(:portrait)[:dimensions].map { |d| d[:name] }
      expect(dimension_names).to include(dimension1.name, dimension2.name)
    end

    it 'renders the portrait template' do
      get :portrait
      expect(response).to render_template(:portrait)
    end
  end
end
