# Module 1 RSpec Tests

This directory contains comprehensive RSpec tests for Module 1: Database Foundation.

## 📋 Test Coverage

### Model Specs (5 files)

1. **`spec/models/user_spec.rb`** - User model tests
   - Associations (user_answers, user_value_portraits, value_dimensions)
   - Validations (email, name, onboarding_progress)
   - Scopes (onboarding_completed, onboarding_incomplete, recent)
   - Methods (portrait_complete?, skip_question!, update_onboarding_progress!)

2. **`spec/models/value_dimension_spec.rb`** - ValueDimension model tests
   - Associations (questions, user_value_portraits, users)
   - Validations (key format, uniqueness)
   - Scopes (active, ordered, with_questions)
   - Methods (question_count, user_count, average_position)

3. **`spec/models/question_spec.rb`** - Question model tests
   - Associations (value_dimension, user_answers, users)
   - Validations (text, question_type, difficulty_score)
   - Scopes (active, by_type, for_dimension, easy/medium/hard)
   - Methods (answer_count, average_answer_value, difficulty_label)

4. **`spec/models/user_value_portrait_spec.rb`** - UserValuePortrait model tests
   - Associations (user, value_dimension)
   - Validations (position, intensity, confidence ranges)
   - Scopes (high_confidence, strong_position, moderate_position)
   - Methods (left_leaning?, strong?, position_label)

5. **`spec/models/user_answer_spec.rb`** - UserAnswer model tests
   - Associations (user, question)
   - Validations (answer_data, value ranges per question type)
   - Scopes (recent, for_dimension, by_question_type)
   - Methods (value, normalized_value, time_spent)

### Factories (5 files)

All models have comprehensive FactoryBot factories with traits:

- **`spec/factories/users.rb`** - User factory with traits
- **`spec/factories/value_dimensions.rb`** - ValueDimension factory with traits
- **`spec/factories/questions.rb`** - Question factory with traits for each type
- **`spec/factories/user_value_portraits.rb`** - UserValuePortrait factory with position traits
- **`spec/factories/user_answers.rb`** - UserAnswer factory with answer type traits

## 🚀 Running the Tests

### Prerequisites

Make sure you have the required gems installed:

```bash
# Check Gemfile for these gems:
# gem 'rspec-rails', '~> 6.0'
# gem 'factory_bot_rails', '~> 6.2'
# gem 'shoulda-matchers', '~> 5.3'
# gem 'faker', '~> 3.2'

bundle install
```

### Setup Test Database

```bash
# Create and migrate test database
RAILS_ENV=test bundle exec rails db:create
RAILS_ENV=test bundle exec rails db:migrate
```

### Run All Tests

```bash
# Run all specs
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run with color output
bundle exec rspec --color
```

### Run Specific Test Files

```bash
# Run all model specs
bundle exec rspec spec/models

# Run specific model spec
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/models/value_dimension_spec.rb
bundle exec rspec spec/models/question_spec.rb
bundle exec rspec spec/models/user_value_portrait_spec.rb
bundle exec rspec spec/models/user_answer_spec.rb
```

### Run Specific Tests

```bash
# Run specific test by line number
bundle exec rspec spec/models/user_spec.rb:27

# Run tests matching a pattern
bundle exec rspec spec/models/user_spec.rb -e "portrait_complete?"
```

### Generate Coverage Report

If you have SimpleCov installed:

```bash
# Add to Gemfile:
# gem 'simplecov', require: false

# Run tests with coverage
COVERAGE=true bundle exec rspec

# Open coverage report
open coverage/index.html
```

## 📊 Expected Test Results

All tests should pass with:

```
Finished in X.XX seconds (files took X.XX seconds to load)
XXX examples, 0 failures
```

### Test Statistics

| Model | Test Count (approx) |
|-------|---------------------|
| User | 25+ examples |
| ValueDimension | 20+ examples |
| Question | 25+ examples |
| UserValuePortrait | 30+ examples |
| UserAnswer | 35+ examples |
| **Total** | **135+ examples** |

## 🐛 Troubleshooting

### Issue: Database not found

```bash
RAILS_ENV=test bundle exec rails db:create db:migrate
```

### Issue: Pending migrations

```bash
RAILS_ENV=test bundle exec rails db:migrate
```

### Issue: Factory not found

Make sure FactoryBot is properly configured in `spec/rails_helper.rb`:

```ruby
config.include FactoryBot::Syntax::Methods
```

### Issue: Shoulda matchers not working

Check that `spec/support/shoulda_matchers.rb` exists and is loaded.

### Issue: BCrypt errors

Make sure bcrypt gem is installed:

```bash
bundle add bcrypt
```

## 📝 Writing New Tests

### Example Test Structure

```ruby
require 'rails_helper'

RSpec.describe MyModel, type: :model do
  describe 'associations' do
    it { should belong_to(:parent) }
    it { should have_many(:children) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#my_method' do
    it 'does something' do
      instance = create(:my_model)
      expect(instance.my_method).to eq('expected_value')
    end
  end
end
```

## ✅ Success Criteria

- [ ] All 5 model specs pass
- [ ] All factories work correctly
- [ ] No pending migrations
- [ ] Test coverage > 90%
- [ ] No deprecation warnings

## 🎯 Next Steps

Once all Module 1 tests pass:

1. **Run tests regularly** during development
2. **Add tests** for new features
3. **Maintain coverage** above 90%
4. **Set up CI/CD** to run tests automatically

---

**Happy Testing!** 🚀

