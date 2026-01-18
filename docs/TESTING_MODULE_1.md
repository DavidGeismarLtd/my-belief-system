# Module 1: Quick Testing Guide

## 🚀 Quick Start

```bash
# 1. Create and migrate database
bundle exec rails db:create db:migrate

# 2. Seed data
bundle exec rails db:seed

# 3. Open console
bundle exec rails console
```

---

## ✅ Quick Validation Tests

### Test 1: Check Data Loaded

```ruby
# Should return 8
ValueDimension.count

# Should return 18
Question.count

# Should show all dimension keys
ValueDimension.pluck(:key)
# => ["liberty_authority", "economic_equality", "tradition_progress", ...]

# Should show question type distribution
Question.group(:question_type).count
# => {"direct_value"=>12, "tradeoff_slider"=>3, "dilemma"=>2, "policy_preference"=>1}
```

---

### Test 2: Create a User and Answer Questions

```ruby
# Create user
user = User.create!(
  email: 'alice@example.com',
  name: 'Alice',
  encrypted_password: BCrypt::Password.create('password123')
)

# Get first question
q1 = Question.first

# Answer question
answer = UserAnswer.create!(
  user: user,
  question: q1,
  answer_data: { value: 4, time_spent_seconds: 15 }
)

# Check answer
answer.value  # => 4
answer.normalized_value  # => 50.0

# Check user progress
user.reload
user.answered_question_count  # => 1
user.onboarding_progress  # => 5 (1/18 * 100)
```

---

### Test 3: Create Value Portrait

```ruby
# Get a dimension
dim = ValueDimension.find_by(key: 'liberty_authority')

# Create portrait
portrait = UserValuePortrait.create!(
  user: user,
  value_dimension: dim,
  position: 65.0,
  intensity: 75.0,
  confidence: 80.0
)

# Check portrait
portrait.right_leaning?  # => true
portrait.strong?  # => true
portrait.position_label  # => "Strong Individual Liberty"
```

---

### Test 4: Test Associations

```ruby
# User associations
user.user_answers.count  # => 1
user.user_value_portraits.count  # => 1
user.answered_questions.first.text  # => question text

# Dimension associations
dim.questions.count  # => 3
dim.user_value_portraits.count  # => 1

# Question associations
q1.user_answers.count  # => 1
q1.users.first  # => user
```

---

### Test 5: Test Validations

```ruby
# Invalid email
User.create(email: 'not-an-email').errors.full_messages

# Duplicate email
User.create(email: 'alice@example.com').errors.full_messages

# Invalid question type
Question.create(
  value_dimension: dim,
  text: 'Test?',
  question_type: 'invalid',
  position: 99
).errors.full_messages

# Invalid answer value
UserAnswer.create(
  user: user,
  question: q1,
  answer_data: { value: 10 }  # Too high for direct_value (max 5)
).errors.full_messages
```

---

### Test 6: Test Scopes

```ruby
# Active dimensions
ValueDimension.active.count  # => 8

# Active questions
Question.active.count  # => 18

# Questions by difficulty
Question.easy.count  # => 6
Question.medium.count  # => 9
Question.hard.count  # => 3

# Questions by type
Question.by_type('direct_value').count  # => 12

# Questions for dimension
Question.for_dimension(dim.id).count  # => 3
```

---

### Test 7: Test User Methods

```ruby
# Can skip question?
user.can_skip_question?  # => true

# Skip a question
user.skip_question!(Question.second.id)
user.skipped_question_count  # => 1

# Update progress
user.update_onboarding_progress!
user.onboarding_progress  # => 5

# Portrait complete?
user.portrait_complete?  # => false (needs 8 portraits)
```

---

## 🎯 Expected Results Summary

| Test | Expected Result |
|------|----------------|
| ValueDimension.count | 8 |
| Question.count | 18 |
| User creation | Success |
| UserAnswer creation | Success |
| UserValuePortrait creation | Success |
| Invalid email | Validation error |
| Duplicate answer | Validation error |
| Associations | All working |
| Scopes | Return correct counts |
| User methods | Return expected values |

---

## 🐛 Common Issues

### Issue: Migration fails

**Solution**:
```bash
# Drop and recreate
bundle exec rails db:drop db:create db:migrate
```

### Issue: Seed fails

**Solution**:
```bash
# Check for syntax errors
ruby -c db/seeds/value_dimensions.rb
ruby -c db/seeds/questions.rb

# Reset and re-seed
bundle exec rails db:reset
```

### Issue: BCrypt error

**Solution**:
```bash
# Add bcrypt to Gemfile
echo 'gem "bcrypt", "~> 3.1.7"' >> Gemfile
bundle install
```

---

## ✅ Success Criteria

- [ ] All migrations run without errors
- [ ] 8 value dimensions created
- [ ] 18 questions created
- [ ] Can create users
- [ ] Can create answers
- [ ] Can create portraits
- [ ] All validations work
- [ ] All associations work
- [ ] All scopes work
- [ ] All methods work

**If all checked → Module 1 is complete!** 🎉

---

## 📞 Next Steps

Once all tests pass:

1. **Commit changes**
2. **Move to Module 2** (Authentication)
3. **Install gems**: devise, jwt, pundit
4. **Implement controllers** from M2 documentation

---

**Happy Testing!** 🚀

