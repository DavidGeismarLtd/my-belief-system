require 'rails_helper'

RSpec.describe "Radar Chart Display", type: :feature, js: false do
  let(:user) { create(:user, :onboarding_completed) }
  let!(:dimension1) { create(:value_dimension, key: 'liberty_authority', name: 'Individual Liberty vs Collective Authority') }
  let!(:dimension2) { create(:value_dimension, key: 'economic_equality', name: 'Economic Equality') }
  let!(:dimension3) { create(:value_dimension, key: 'tradition_progress', name: 'Tradition vs Progress') }

  let!(:actor) do
    create(:actor, :personality,
      name: 'Test Politician',
      role: 'Senator',
      party_affiliation: 'Democratic Party',
      metadata: {
        value_positions: {
          dimension1.id => -30,
          dimension2.id => 50,
          dimension3.id => 20
        }
      }
    )
  end

  before do
    # Create user value portraits
    create(:user_value_portrait, user: user, value_dimension: dimension1, position: -50, intensity: 75, confidence: 80)
    create(:user_value_portrait, user: user, value_dimension: dimension2, position: 30, intensity: 60, confidence: 70)
    create(:user_value_portrait, user: user, value_dimension: dimension3, position: -10, intensity: 40, confidence: 65)

    login_as(user, scope: :user)
  end

  describe "Value Portrait Page" do
    before do
      visit my_values_path
    end

    it "displays the value portrait page" do
      expect(page).to have_content('Your Value Portrait')
    end

    it "renders radar chart controller element" do
      expect(page).to have_selector('[data-controller="radar-chart"]')
    end

    it "includes radar chart data attributes" do
      expect(page).to have_selector('[data-radar-chart-dimensions-value]')
      expect(page).to have_selector('[data-radar-chart-user-values-value]')
    end

    it "displays dimension breakdown" do
      # The controller uses mock data, so we check for the mock dimension names
      expect(page).to have_content('Individual Liberty vs Collective Authority')
      expect(page).to have_content('Economic Equality vs Free Market')
      expect(page).to have_content('Traditional Values vs Progressive Values')
    end

    it "shows intensity and confidence values" do
      # Values are displayed as decimals (0.75) not percentages (75%)
      expect(page).to have_content('0.75') # intensity
      expect(page).to have_content('0.85') # confidence
    end

    it "includes CTA to dashboard" do
      expect(page).to have_link('See How Politicians Align', href: dashboard_path)
    end
  end

  describe "Actor Show Page" do
    before do
      visit actor_path(actor)
    end

    it "displays the actor show page" do
      expect(page).to have_content('Test Politician')
    end

    it "renders radar chart controller element for comparison" do
      expect(page).to have_selector('[data-controller="radar-chart"]')
    end

    it "includes comparison mode data attributes" do
      expect(page).to have_selector('[data-radar-chart-dimensions-value]')
      expect(page).to have_selector('[data-radar-chart-user-values-value]')
      expect(page).to have_selector('[data-radar-chart-actor-values-value]')
      expect(page).to have_selector('[data-radar-chart-show-comparison-value="true"]')
    end

    it "displays actor information" do
      expect(page).to have_content('Test Politician')
      expect(page).to have_content('Senator')
      expect(page).to have_content('Democratic Party')
    end

    it "displays dimension comparisons" do
      expect(page).to have_content(dimension1.name)
      expect(page).to have_content(dimension2.name)
      expect(page).to have_content(dimension3.name)
    end

    it "shows alignment percentages" do
      expect(page).to have_content('%') # alignment percentages
    end

    it "includes tabs for Overview and Detailed Analysis" do
      expect(page).to have_content('Overview')
      expect(page).to have_content('Detailed Analysis')
    end
  end

  describe "Onboarding Portrait Page" do
    before do
      visit onboarding_portrait_path
    end

    it "displays the onboarding portrait page" do
      expect(page).to have_content('Your Value Portrait')
    end

    it "renders radar chart controller element" do
      expect(page).to have_selector('[data-controller="radar-chart"]')
    end

    it "includes radar chart data attributes" do
      expect(page).to have_selector('[data-radar-chart-dimensions-value]')
      expect(page).to have_selector('[data-radar-chart-user-values-value]')
    end

    it "displays dimension breakdown" do
      expect(page).to have_content(dimension1.name)
      expect(page).to have_content(dimension2.name)
      expect(page).to have_content(dimension3.name)
    end

    it "includes button to save and view dashboard" do
      expect(page).to have_button('Save & View My Dashboard')
    end
  end

  describe "Dashboard Page" do
    before do
      visit dashboard_path
    end

    it "displays the dashboard page" do
      expect(page).to have_content('Your Alignment Dashboard')
    end

    it "displays actors" do
      expect(page).to have_content('Test Politician')
    end

    it "includes links to actor detail pages" do
      expect(page).to have_link('View Details', href: actor_path(actor))
    end
  end
end
