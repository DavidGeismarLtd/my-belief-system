# JavaScript Testing Guide

## Current Status

**JavaScript testing is NOT currently set up** for this project. The application uses:
- **importmap-rails** for JavaScript module management (not npm/webpack)
- **Stimulus** for JavaScript controllers
- **No JavaScript test framework** (no Jest, Jasmine, or similar)

## Testing Strategy

For now, JavaScript functionality is tested through:

1. **RSpec View Specs** - Test that data attributes are correctly rendered
2. **RSpec Feature Specs** - Test end-to-end behavior (without JS execution)
3. **Manual Testing** - Test interactive behavior in the browser

## Future: Adding JavaScript Testing

If you want to add JavaScript testing in the future, here are the recommended approaches:

### Option 1: Stimulus Testing Library (Recommended for Stimulus apps)

```bash
# Install dependencies
npm install --save-dev @testing-library/dom @testing-library/jest-dom jest
```

**Example test for radar_chart_controller.js:**

```javascript
// spec/javascript/controllers/radar_chart_controller.test.js
import { Application } from "@hotwired/stimulus"
import RadarChartController from "controllers/radar_chart_controller"

describe("RadarChartController", () => {
  let application
  let controller

  beforeEach(() => {
    application = Application.start()
    application.register("radar-chart", RadarChartController)
    
    document.body.innerHTML = `
      <div data-controller="radar-chart"
           data-radar-chart-dimensions-value='["Dim 1", "Dim 2", "Dim 3"]'
           data-radar-chart-user-values-value='[50, 30, -20]'
           data-radar-chart-show-comparison-value="false">
        <svg data-radar-chart-target="svg"></svg>
        <div data-radar-chart-target="tooltip"></div>
      </div>
    `
    
    controller = application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller="radar-chart"]'),
      "radar-chart"
    )
  })

  afterEach(() => {
    application.stop()
  })

  test("initializes with correct data", () => {
    expect(controller.dimensionsValue).toEqual(["Dim 1", "Dim 2", "Dim 3"])
    expect(controller.userValuesValue).toEqual([50, 30, -20])
    expect(controller.showComparisonValue).toBe(false)
  })

  test("renders SVG chart", () => {
    const svg = document.querySelector('[data-radar-chart-target="svg"]')
    expect(svg.children.length).toBeGreaterThan(0)
  })

  test("creates correct number of axes", () => {
    const svg = document.querySelector('[data-radar-chart-target="svg"]')
    const axes = svg.querySelectorAll('line.axis')
    expect(axes.length).toBe(3)
  })
})
```

### Option 2: Capybara with Selenium (For full browser testing)

Already available in the project! Just add `js: true` to feature specs:

```ruby
# spec/features/radar_chart_interaction_spec.rb
require 'rails_helper'

RSpec.describe "Radar Chart Interactions", type: :feature, js: true do
  it "shows tooltip on hover" do
    visit value_portraits_show_path
    
    # Hover over a data point
    find('[data-radar-chart-target="svg"] circle', match: :first).hover
    
    # Expect tooltip to be visible
    expect(page).to have_selector('[data-radar-chart-target="tooltip"]:not(.hidden)')
  end
end
```

**Setup for Selenium:**

```ruby
# spec/rails_helper.rb
require 'capybara/rails'
require 'selenium/webdriver'

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome_headless
```

### Option 3: System Tests (Rails built-in)

Rails 8.1 includes system tests with Selenium by default:

```ruby
# test/system/radar_charts_test.rb
require "application_system_test_case"

class RadarChartsTest < ApplicationSystemTestCase
  test "displays radar chart on value portrait page" do
    visit value_portraits_show_path
    
    assert_selector '[data-controller="radar-chart"]'
    assert_selector '[data-radar-chart-target="svg"]'
  end
  
  test "shows tooltip on hover" do
    visit value_portraits_show_path
    
    find('[data-radar-chart-target="svg"] circle', match: :first).hover
    
    assert_selector '[data-radar-chart-target="tooltip"]:not(.hidden)'
  end
end
```

## Current Test Coverage

The radar chart functionality is currently tested through:

1. **Controller Specs** (`spec/controllers/`)
   - `actors_controller_spec.rb` - Tests actor data structure and dimension comparisons
   - `value_portraits_controller_spec.rb` - Tests portrait data structure

2. **View Specs** (`spec/views/`)
   - `actors/show.html.erb_spec.rb` - Tests radar chart data attributes in actor view
   - `value_portraits/show.html.erb_spec.rb` - Tests radar chart data attributes in portrait view

3. **Feature Specs** (`spec/features/`)
   - `radar_chart_display_spec.rb` - Tests end-to-end page rendering and data presence

## Running Tests

```bash
# Run all specs
bundle exec rspec

# Run specific test files
bundle exec rspec spec/controllers/actors_controller_spec.rb
bundle exec rspec spec/views/actors/show.html.erb_spec.rb
bundle exec rspec spec/features/radar_chart_display_spec.rb

# Run with documentation format
bundle exec rspec --format documentation

# Run with coverage report (if SimpleCov is installed)
COVERAGE=true bundle exec rspec
```

## Manual Testing Checklist

Since JavaScript tests are not automated, use this checklist for manual testing:

### Radar Chart - Value Portrait Page
- [ ] Chart renders with correct number of axes (8 dimensions)
- [ ] Data points are positioned correctly
- [ ] Hover over data point shows tooltip
- [ ] Tooltip displays dimension name and value
- [ ] Chart is responsive on mobile/tablet/desktop
- [ ] No console errors

### Radar Chart - Actor Show Page (Comparison Mode)
- [ ] Chart renders with two overlapping polygons (user + actor)
- [ ] User data is blue, actor data is red
- [ ] Hover shows tooltip for both user and actor values
- [ ] Tooltip displays dimension name, user value, and actor value
- [ ] Chart is responsive on mobile/tablet/desktop
- [ ] No console errors

### Radar Chart - Onboarding Portrait Page
- [ ] Chart renders after completing onboarding questions
- [ ] Data reflects user's answers
- [ ] Chart updates if user changes answers
- [ ] No console errors

## Recommendations

For this MVP project, the current testing approach (RSpec + manual testing) is sufficient. Consider adding JavaScript testing when:

1. The application grows more complex
2. You have multiple interactive Stimulus controllers
3. You need to test complex user interactions
4. You want to prevent regressions in JavaScript behavior
5. You have a dedicated frontend developer on the team

