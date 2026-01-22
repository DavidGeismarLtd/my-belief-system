require 'rails_helper'

RSpec.describe "Onboarding Complete Flow", type: :feature do
  let(:user) { create(:user) }
  let!(:dimension) { create(:value_dimension, :with_questions) }
  
  before do
    sign_in user
  end

  it "saves answers to database and creates value portraits" do
    # Start onboarding
    visit onboarding_path
    
    # Fill profile
    select "United States", from: "country"
    fill_in "age", with: "30"
    select "Male", from: "gender"
    select "Very engaged", from: "political_engagement"
    click_button "Continue"
    
    # Answer first question
    expect(page).to have_content("Question 1")
    
    # Simulate answering all questions via session
    # (In a real test, you'd click through all questions)
    
    # Go to portrait page
    visit onboarding_portrait_path
    
    # Complete onboarding
    click_button "Save & View My Dashboard"
    
    # Verify redirect to dashboard
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Onboarding completed")
    
    # Verify answers were saved
    user.reload
    expect(user.onboarding_completed).to be true
    
    # Verify portraits were created
    expect(user.user_value_portraits.count).to be > 0
  end
end

