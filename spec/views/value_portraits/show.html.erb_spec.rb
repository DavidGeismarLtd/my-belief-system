require 'rails_helper'

RSpec.describe "value_portraits/show.html.erb", type: :view do
  include Warden::Test::Helpers
  let!(:dimension1) { create(:value_dimension, key: 'liberty_authority', name: 'Individual Liberty vs Collective Authority', left_pole: 'Individual Liberty', right_pole: 'Collective Authority') }
  let!(:dimension2) { create(:value_dimension, key: 'economic_equality', name: 'Economic Equality', left_pole: 'Economic Equality', right_pole: 'Free Market') }
  let!(:dimension3) { create(:value_dimension, key: 'tradition_progress', name: 'Tradition vs Progress', left_pole: 'Tradition', right_pole: 'Progress') }

  let(:portrait_data) do
    {
      created_at: 2.weeks.ago,
      dimensions: [
        {
          id: dimension1.id,
          name: dimension1.name,
          left_pole: dimension1.left_pole,
          right_pole: dimension1.right_pole,
          position: -50,
          intensity: 75,
          confidence: 80,
          lean: 'left',
          lean_label: 'Strong Individual Liberty',
          explanation: 'You strongly favor individual liberty over collective authority.'
        },
        {
          id: dimension2.id,
          name: dimension2.name,
          left_pole: dimension2.left_pole,
          right_pole: dimension2.right_pole,
          position: 30,
          intensity: 60,
          confidence: 70,
          lean: 'right',
          lean_label: 'Lean Free Market',
          explanation: 'You moderately favor free market over economic equality.'
        },
        {
          id: dimension3.id,
          name: dimension3.name,
          left_pole: dimension3.left_pole,
          right_pole: dimension3.right_pole,
          position: -5,
          intensity: 40,
          confidence: 65,
          lean: 'center',
          lean_label: 'Balanced',
          explanation: 'You are balanced between tradition and progress.'
        }
      ]
    }
  end

  before do
    assign(:portrait, portrait_data)

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

    it 'sets show comparison to false for single user view' do
      expect(rendered).to have_selector('[data-radar-chart-show-comparison-value="false"]')
    end

    it 'includes SVG target for radar chart' do
      expect(rendered).to have_selector('[data-radar-chart-target="svg"]')
    end

    it 'includes tooltip target for radar chart' do
      expect(rendered).to have_selector('[data-radar-chart-target="tooltip"]')
    end
  end

  describe 'dimension breakdown rendering' do
    it 'displays all dimensions' do
      portrait_data[:dimensions].each do |dimension|
        expect(rendered).to have_content(dimension[:name])
      end
    end

    it 'displays lean labels' do
      # The view displays simplified lean labels, not the full lean_label from data
      expect(rendered).to have_content('Individual')
      expect(rendered).to have_content('Free')
      expect(rendered).to have_content('Balanced')
    end

    it 'displays intensity values' do
      # Values are displayed as decimals (0.75) not percentages (75%)
      portrait_data[:dimensions].each do |dimension|
        intensity_decimal = (dimension[:intensity] / 100.0).to_s
        expect(rendered).to have_content(intensity_decimal)
      end
    end

    it 'displays confidence values' do
      # Values are displayed as decimals (0.8) not percentages (80%)
      portrait_data[:dimensions].each do |dimension|
        confidence_decimal = (dimension[:confidence] / 100.0).to_s
        expect(rendered).to have_content(confidence_decimal)
      end
    end

    it 'displays explanations' do
      portrait_data[:dimensions].each do |dimension|
        expect(rendered).to have_content(dimension[:explanation])
      end
    end
  end

  describe 'page structure' do
    it 'displays page title' do
      expect(rendered).to have_content('Your Value Portrait')
    end

    it 'includes CTA button to dashboard' do
      expect(rendered).to have_link('See How Politicians Align', href: dashboard_path)
    end
  end

  describe 'gradient styling' do
    it 'includes gradient background classes' do
      expect(rendered).to match(/bg-gradient-to-br/)
    end

    it 'includes gradient text classes' do
      expect(rendered).to match(/bg-gradient-to-r/)
    end
  end

  describe 'responsive design' do
    it 'includes responsive classes for mobile' do
      expect(rendered).to match(/sm:/)
    end

    it 'includes responsive grid classes' do
      # The view uses sm:grid-cols-3 for responsive grids
      expect(rendered).to match(/sm:grid-cols-3/)
    end

    it 'includes responsive text sizing' do
      # The view uses sm:text-4xl and sm:text-3xl for responsive text
      expect(rendered).to match(/sm:text-/)
    end
  end
end
