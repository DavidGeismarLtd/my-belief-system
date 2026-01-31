require 'rails_helper'

RSpec.describe "actors/show.html.erb", type: :view do
  include Warden::Test::Helpers
  let!(:dimension1) { create(:value_dimension, key: 'liberty_authority', name: 'Individual Liberty vs Collective Authority') }
  let!(:dimension2) { create(:value_dimension, key: 'economic_equality', name: 'Economic Equality') }
  let!(:dimension3) { create(:value_dimension, key: 'tradition_progress', name: 'Tradition vs Progress') }

  let(:actor_data) do
    {
      id: 1,
      name: 'Test Politician',
      type: 'Personality',
      location: 'United States',
      role: 'Senator',
      party: 'Democratic Party',
      description: 'A test politician',
      image_url: 'https://example.com/image.jpg',
      alignment_score: 75,
      dimensions: [
        {
          id: dimension1.id,
          name: dimension1.name,
          user_position: -50,
          actor_position: -30,
          alignment: 80,
          alignment_label: 'Strong'
        },
        {
          id: dimension2.id,
          name: dimension2.name,
          user_position: 30,
          actor_position: 50,
          alignment: 75,
          alignment_label: 'Strong'
        },
        {
          id: dimension3.id,
          name: dimension3.name,
          user_position: -10,
          actor_position: 20,
          alignment: 70,
          alignment_label: 'Moderate'
        }
      ]
    }
  end

  let(:user_portrait_data) do
    {
      dimensions: [
        { id: dimension1.id, name: dimension1.name, position: -50, intensity: 75, confidence: 80 },
        { id: dimension2.id, name: dimension2.name, position: 30, intensity: 60, confidence: 70 },
        { id: dimension3.id, name: dimension3.name, position: -10, intensity: 40, confidence: 65 }
      ]
    }
  end

  before do
    assign(:actor, actor_data)
    assign(:user_portrait, user_portrait_data)

    # Create a user for authentication context
    user = create(:user, :onboarding_completed)
    login_as(user, scope: :user)

    render
  end

  describe 'radar chart integration' do
    it 'renders a radar chart controller element' do
      expect(rendered).to have_selector('[data-controller="radar-chart"]')
    end

    it 'includes radar chart dimensions data attribute' do
      expect(rendered).to have_selector('[data-radar-chart-dimensions-value]')
    end

    it 'includes radar chart user values data attribute' do
      expect(rendered).to have_selector('[data-radar-chart-user-values-value]')
    end

    it 'includes radar chart actor values data attribute' do
      expect(rendered).to have_selector('[data-radar-chart-actor-values-value]')
    end

    it 'includes radar chart actor name data attribute' do
      expect(rendered).to have_selector('[data-radar-chart-actor-name-value]')
    end

    it 'includes radar chart show comparison data attribute' do
      expect(rendered).to have_selector('[data-radar-chart-show-comparison-value="true"]')
    end

    it 'includes SVG target for radar chart' do
      expect(rendered).to have_selector('[data-radar-chart-target="svg"]')
    end

    it 'includes tooltip target for radar chart' do
      expect(rendered).to have_selector('[data-radar-chart-target="tooltip"]')
    end
  end

  describe 'dimension data rendering' do
    it 'displays all dimensions' do
      actor_data[:dimensions].each do |dimension|
        expect(rendered).to have_content(dimension[:name])
      end
    end

    it 'displays alignment percentages' do
      actor_data[:dimensions].each do |dimension|
        expect(rendered).to have_content("#{dimension[:alignment]}%")
      end
    end
  end

  describe 'actor information' do
    it 'displays actor name' do
      expect(rendered).to have_content('Test Politician')
    end

    it 'displays actor role' do
      expect(rendered).to have_content('Senator')
    end

    it 'displays actor party' do
      expect(rendered).to have_content('Democratic Party')
    end

    it 'displays overall alignment score' do
      expect(rendered).to have_content('75%')
    end
  end

  describe 'tabs functionality' do
    it 'includes tabs controller element' do
      expect(rendered).to have_selector('[data-controller*="tabs"]')
    end

    it 'includes Overview tab' do
      expect(rendered).to have_content('Overview')
    end

    it 'includes Detailed Analysis tab' do
      expect(rendered).to have_content('Detailed Analysis')
    end
  end
end
