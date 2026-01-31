require 'rails_helper'

RSpec.describe "Actors", type: :request do
  let(:user) { create(:user, :onboarding_completed) }
  let!(:dimension1) { create(:value_dimension, key: 'liberty_authority', name: 'Individual Liberty vs Collective Authority') }
  let!(:dimension2) { create(:value_dimension, key: 'economic_equality', name: 'Economic Equality') }
  let!(:dimension3) { create(:value_dimension, key: 'tradition_progress', name: 'Tradition vs Progress') }
  let!(:actor) do
    create(
      :actor,
      name: 'Democratic Party',
      actor_type: 'party',
      metadata: {
        'value_positions' => {
          dimension1.id.to_s => -60,
          dimension2.id.to_s => 40,
          dimension3.id.to_s => -20
        }
      }
    )
  end

  before do
    # Create user value portraits for comparison
    create(:user_value_portrait, user: user, value_dimension: dimension1, position: -50)
    create(:user_value_portrait, user: user, value_dimension: dimension2, position: 30)
    create(:user_value_portrait, user: user, value_dimension: dimension3, position: -10)

    # Sign in using Devise test helper for request specs
    login_as(user, scope: :user)
  end

  describe 'GET /actors/:id' do
    before do
      get actor_path(actor)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns actor data to @actor' do
      expect(assigns(:actor)).to be_present
    end

    it 'assigns user portrait data to @user_portrait' do
      expect(assigns(:user_portrait)).to be_present
    end

    describe '@actor data structure' do
      let(:actor_data) { assigns(:actor) }

      it 'includes basic actor information' do
        expect(actor_data[:id]).to eq(actor.id)
        expect(actor_data[:name]).to eq('Democratic Party')
        expect(actor_data[:type]).to eq('Party')
      end

      it 'includes alignment score' do
        expect(actor_data[:alignment_score]).to be_a(Numeric)
        expect(actor_data[:alignment_score]).to be_between(0, 100)
      end

      it 'includes dimensions array' do
        expect(actor_data[:dimensions]).to be_an(Array)
        expect(actor_data[:dimensions].length).to eq(3)
      end

      describe 'dimension data structure' do
        let(:dimension_data) { actor_data[:dimensions].first }

        it 'includes dimension name' do
          expect(dimension_data[:name]).to be_a(String)
        end

        it 'includes user position' do
          expect(dimension_data[:user_position]).to be_a(Numeric)
          expect(dimension_data[:user_position]).to be_between(-100, 100)
        end

        it 'includes actor position' do
          expect(dimension_data[:actor_position]).to be_a(Numeric)
          expect(dimension_data[:actor_position]).to be_between(-100, 100)
        end

        it 'includes alignment percentage' do
          expect(dimension_data[:alignment]).to be_a(Numeric)
          expect(dimension_data[:alignment]).to be_between(0, 100)
        end
      end
    end

    describe '@user_portrait data structure' do
      let(:user_portrait) { assigns(:user_portrait) }

      it 'includes dimensions array' do
        expect(user_portrait[:dimensions]).to be_an(Array)
        expect(user_portrait[:dimensions].length).to eq(3)
      end

      describe 'user dimension data' do
        let(:dimension_data) { user_portrait[:dimensions].first }

        it 'includes dimension name' do
          expect(dimension_data[:name]).to be_a(String)
        end

        it 'includes position' do
          expect(dimension_data[:position]).to be_a(Numeric)
          expect(dimension_data[:position]).to be_between(-100, 100)
        end
      end
    end

    describe 'actor value positions from metadata' do
      it 'retrieves actor positions from metadata' do
        actor_data = assigns(:actor)
        dimension_data = actor_data[:dimensions].find { |d| d[:name] == 'Individual Liberty vs Collective Authority' }
        expect(dimension_data[:actor_position]).to eq(-60)
      end
    end
  end
end
