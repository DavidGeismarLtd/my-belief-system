require 'rails_helper'

RSpec.describe "ValuePortraits", type: :request do
  let(:user) { create(:user, :onboarding_completed) }
  let!(:dimension1) { create(:value_dimension, key: 'liberty_authority', name: 'Individual Liberty vs Collective Authority') }
  let!(:dimension2) { create(:value_dimension, key: 'economic_equality', name: 'Economic Equality') }
  let!(:dimension3) { create(:value_dimension, key: 'tradition_progress', name: 'Tradition vs Progress') }

  before do
    # Create user value portraits
    create(:user_value_portrait, user: user, value_dimension: dimension1, position: -50, intensity: 75, confidence: 80)
    create(:user_value_portrait, user: user, value_dimension: dimension2, position: 30, intensity: 60, confidence: 70)
    create(:user_value_portrait, user: user, value_dimension: dimension3, position: -10, intensity: 40, confidence: 65)

    # Sign in using Devise test helper for request specs
    login_as(user, scope: :user)
  end

  describe 'GET /my-values' do
    before do
      get "/my-values"
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns portrait data to @portrait' do
      expect(assigns(:portrait)).to be_present
    end

    describe '@portrait data structure' do
      let(:portrait) { assigns(:portrait) }

      it 'includes dimensions array' do
        expect(portrait[:dimensions]).to be_an(Array)
        expect(portrait[:dimensions].length).to be > 0
      end

      describe 'dimension data structure' do
        let(:dimension_data) { portrait[:dimensions].first }

        it 'includes dimension name' do
          expect(dimension_data[:name]).to be_a(String)
        end

        it 'includes left and right poles' do
          expect(dimension_data[:left_pole]).to be_a(String)
          expect(dimension_data[:right_pole]).to be_a(String)
        end

        it 'includes position' do
          expect(dimension_data[:position]).to be_a(Numeric)
          expect(dimension_data[:position]).to be_between(-100, 100)
        end

        it 'includes intensity' do
          expect(dimension_data[:intensity]).to be_a(Numeric)
        end

        it 'includes confidence' do
          expect(dimension_data[:confidence]).to be_a(Numeric)
        end

        it 'includes explanation' do
          expect(dimension_data[:explanation]).to be_a(String)
        end
      end
    end
  end
end
