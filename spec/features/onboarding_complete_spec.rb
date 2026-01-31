require 'rails_helper'

RSpec.describe "Onboarding Complete Flow", type: :feature do
  let(:user) { create(:user) }
  let!(:dimension) { create(:value_dimension) }
  let!(:question1) { create(:question, value_dimension: dimension, position: 1, is_universal: true) }
  let!(:question2) { create(:question, value_dimension: dimension, position: 2, is_universal: true) }

  before do
    login_as(user, scope: :user)
  end

  it "completes onboarding flow and redirects to dashboard" do
    # Start onboarding
    visit onboarding_path

    # Fill profile
    select "United States", from: "country"
    fill_in "age", with: "30"
    select "Male", from: "gender"
    select "Very engaged", from: "political_engagement"
    click_button "Continue"

    # Should be on first question
    expect(page).to have_content("Question 1")

    # Visit portrait page (simulating completing all questions)
    visit onboarding_portrait_path

    # Complete onboarding
    click_button "Save & View My Dashboard"

    # Verify redirect to dashboard
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Onboarding completed")
  end
end
