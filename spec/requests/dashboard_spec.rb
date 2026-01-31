require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let(:user) { create(:user, :onboarding_completed) }

  before do
    login_as(user, scope: :user)
  end

  describe 'GET /dashboard' do
    let!(:party) { create(:actor, :party, name: 'Democratic Party', active: true) }
    let!(:personality) { create(:actor, :personality, name: 'Joe Biden', active: true) }
    let!(:inactive_actor) { create(:actor, active: false) }
    let!(:dimension1) { create(:value_dimension, name: 'Liberty vs Authority') }
    let!(:dimension2) { create(:value_dimension, name: 'Economic Equality') }

    before do
      get dashboard_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns active actors to @actors' do
      expect(assigns(:actors)).to be_present
      expect(assigns(:actors).size).to eq(2)
    end

    it 'does not include inactive actors' do
      actor_names = assigns(:actors).map { |a| a[:name] }
      expect(actor_names).not_to include(inactive_actor.name)
    end

    it 'includes party actors' do
      actor_names = assigns(:actors).map { |a| a[:name] }
      expect(actor_names).to include('Democratic Party')
    end

    it 'includes personality actors' do
      actor_names = assigns(:actors).map { |a| a[:name] }
      expect(actor_names).to include('Joe Biden')
    end

    describe 'actor data structure' do
      let(:actor_data) { assigns(:actors).first }

      it 'includes id' do
        expect(actor_data[:id]).to be_present
      end

      it 'includes name' do
        expect(actor_data[:name]).to be_present
      end

      it 'includes capitalized type' do
        expect(actor_data[:type]).to be_in(['Party', 'Personality', 'Organization'])
      end

      it 'includes location' do
        expect(actor_data[:location]).to be_present
      end

      it 'includes image_url' do
        expect(actor_data).to have_key(:image_url)
      end

      it 'includes alignment_score' do
        expect(actor_data[:alignment_score]).to be_a(Integer)
        expect(actor_data[:alignment_score]).to be_between(0, 100)
      end

      it 'includes alignment_label' do
        expect(actor_data[:alignment_label]).to be_in(['Strong', 'Moderate', 'Weak', 'Misalignment'])
      end

      it 'includes alignment_color' do
        expect(actor_data[:alignment_color]).to be_in(['green', 'blue', 'amber', 'red'])
      end

      it 'includes strong_dimensions array' do
        expect(actor_data[:strong_dimensions]).to be_an(Array)
      end

      it 'includes weak_dimensions array' do
        expect(actor_data[:weak_dimensions]).to be_an(Array)
      end

      it 'includes trend' do
        expect(actor_data[:trend]).to be_in(['up', 'down', 'stable'])
      end

      it 'includes trend_value' do
        expect(actor_data[:trend_value]).to be_a(Float)
      end
    end

    describe 'alignment label logic' do
      it 'returns Strong for scores 80-100' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(85)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_label]).to eq('Strong')
      end

      it 'returns Moderate for scores 60-79' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(65)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_label]).to eq('Moderate')
      end

      it 'returns Weak for scores 40-59' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(45)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_label]).to eq('Weak')
      end

      it 'returns Misalignment for scores below 40' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(25)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_label]).to eq('Misalignment')
      end
    end

    describe 'alignment color logic' do
      it 'returns green for scores 80-100' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(85)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_color]).to eq('green')
      end

      it 'returns blue for scores 60-79' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(65)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_color]).to eq('blue')
      end

      it 'returns amber for scores 40-59' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(45)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_color]).to eq('amber')
      end

      it 'returns red for scores below 40' do
        allow_any_instance_of(DashboardController).to receive(:calculate_mock_alignment_score).and_return(25)
        get dashboard_path
        actor = assigns(:actors).first
        expect(actor[:alignment_color]).to eq('red')
      end
    end
  end
end
