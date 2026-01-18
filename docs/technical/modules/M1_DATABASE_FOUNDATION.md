# Module 1: Database Foundation & Core Models

**Timeline**: Weeks 1-2
**Owner**: Backend Lead
**Team**: 1 Backend Engineer
**Dependencies**: None
**Blocks**: All other modules

---

## Module Overview

This module establishes the foundational database schema and core ActiveRecord models for the First Principles MVP. It includes setting up PostgreSQL, creating migrations for 5 core tables, seeding reference data (8 value dimensions and 24 questions), and implementing model validations and associations.

**Success Criteria**:
- All migrations run successfully
- Seed data loads without errors
- All model tests passing (>90% coverage)
- Database queries perform <50ms

---

## Technical Specifications

### Database Schema

#### 1. Users Table

**Purpose**: Store user accounts and authentication data

```ruby
# db/migrate/20260115000001_create_users.rb
class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # Devise fields
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      # Custom fields
      t.string :name
      t.date :date_of_birth
      t.string :country, default: "US"
      t.boolean :onboarding_completed, default: false
      t.datetime :onboarding_completed_at

      # Tracking
      t.integer :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :onboarding_completed
    add_index :users, :created_at
  end
end
```

**Indexes**:
- `email` (unique): Fast user lookup
- `reset_password_token` (unique): Password reset flow
- `onboarding_completed`: Filter users by onboarding status
- `created_at`: User cohort analysis

---

#### 2. Value Dimensions Table

**Purpose**: Reference data for the 8 core political value dimensions

```ruby
# db/migrate/20260115000002_create_value_dimensions.rb
class CreateValueDimensions < ActiveRecord::Migration[8.1]
  def change
    create_table :value_dimensions do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.text :description
      t.string :left_pole, null: false
      t.string :right_pole, null: false
      t.integer :position, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :value_dimensions, :key, unique: true
    add_index :value_dimensions, :position
    add_index :value_dimensions, :active
  end
end
```

**Fields**:
- `key`: Unique identifier (e.g., "liberty_authority")
- `name`: Display name (e.g., "Individual Liberty vs Collective Authority")
- `description`: Explanation of the dimension
- `left_pole`: Left end label (e.g., "Individual Liberty")
- `right_pole`: Right end label (e.g., "Collective Authority")
- `position`: Display order (1-8)
- `active`: Enable/disable dimensions

**Indexes**:
- `key` (unique): Fast dimension lookup
- `position`: Ordered retrieval
- `active`: Filter active dimensions

---

#### 3. Questions Table

**Purpose**: Store onboarding questions for value portrait creation

```ruby
# db/migrate/20260115000003_create_questions.rb
class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :value_dimension, null: false, foreign_key: true
      t.text :text, null: false
      t.string :question_type, null: false
      t.jsonb :options, default: {}
      t.integer :position
      t.boolean :active, default: true
      t.string :difficulty, default: "medium"

      t.timestamps
    end

    add_index :questions, :value_dimension_id
    add_index :questions, :question_type
    add_index :questions, :active
    add_index :questions, :difficulty
    add_index :questions, [:value_dimension_id, :position]
  end
end
```

**Fields**:
- `value_dimension_id`: Which dimension this question measures
- `text`: Question text
- `question_type`: "direct_value", "policy_preference", "tradeoff", "dilemma"
- `options`: JSONB for answer options and metadata
- `position`: Order within dimension
- `active`: Enable/disable questions
- `difficulty`: "easy", "medium", "hard" for adaptive selection

**Indexes**:
- `value_dimension_id`: Questions by dimension
- `question_type`: Filter by type
- `active`: Active questions only
- `difficulty`: Adaptive question selection
- `[value_dimension_id, position]`: Ordered questions per dimension

---

#### 4. User Value Portraits Table

**Purpose**: Store calculated value portraits for users

```ruby
# db/migrate/20260115000004_create_user_value_portraits.rb
class CreateUserValuePortraits < ActiveRecord::Migration[8.1]
  def change
    create_table :user_value_portraits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :value_dimension, null: false, foreign_key: true

      t.decimal :position, precision: 3, scale: 2, null: false
      t.decimal :intensity, precision: 3, scale: 2, null: false
      t.decimal :confidence, precision: 3, scale: 2, null: false

      t.integer :answer_count, default: 0
      t.datetime :last_calculated_at

      t.timestamps
    end

    add_index :user_value_portraits, [:user_id, :value_dimension_id],
              unique: true, name: 'index_user_portraits_on_user_and_dimension'
    add_index :user_value_portraits, :user_id
    add_index :user_value_portraits, :last_calculated_at
  end
end
```

**Fields**:
- `user_id`: User this portrait belongs to
- `value_dimension_id`: Which dimension
- `position`: -1.0 to +1.0 (left to right on spectrum)
- `intensity`: 0.0 to 1.0 (how strongly held)
- `confidence`: 0.0 to 1.0 (how certain we are)
- `answer_count`: Number of answers contributing to this
- `last_calculated_at`: When portrait was last updated

**Indexes**:
- `[user_id, value_dimension_id]` (unique): One portrait per user per dimension
- `user_id`: All portraits for a user
- `last_calculated_at`: Stale portrait detection

---

#### 5. User Answers Table

**Purpose**: Store user responses to onboarding questions

```ruby
# db/migrate/20260115000005_create_user_answers.rb
class CreateUserAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.jsonb :answer_data, null: false
      t.integer :time_spent_seconds
      t.boolean :skipped, default: false

      t.timestamps
    end

    add_index :user_answers, [:user_id, :question_id], unique: true
    add_index :user_answers, :user_id
    add_index :user_answers, :question_id
    add_index :user_answers, :created_at
    add_index :user_answers, :answer_data, using: :gin
  end
end
```

**Fields**:
- `user_id`: User who answered
- `question_id`: Question answered
- `answer_data`: JSONB storing answer (flexible for different question types)
- `time_spent_seconds`: How long user took to answer
- `skipped`: Whether user skipped this question

**Indexes**:
- `[user_id, question_id]` (unique): One answer per user per question
- `user_id`: All answers for a user
- `question_id`: All answers to a question
- `created_at`: Answer timeline
- `answer_data` (GIN): Fast JSONB queries

---

## Data Models

### User Model

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Associations
  has_many :user_answers, dependent: :destroy
  has_many :user_value_portraits, dependent: :destroy
  has_many :value_dimensions, through: :user_value_portraits

  # Validations
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :country, inclusion: { in: %w[US UK CA AU] }, allow_blank: true

  # Scopes
  scope :onboarded, -> { where(onboarding_completed: true) }
  scope :not_onboarded, -> { where(onboarding_completed: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def complete_onboarding!
    update!(
      onboarding_completed: true,
      onboarding_completed_at: Time.current
    )
  end

  def onboarding_progress
    total_questions = Question.active.count
    answered = user_answers.count
    (answered.to_f / total_questions * 100).round
  end

  def portrait_complete?
    user_value_portraits.count == ValueDimension.active.count
  end
end
```

### ValueDimension Model

```ruby
# app/models/value_dimension.rb
class ValueDimension < ApplicationRecord
  # Associations
  has_many :questions, dependent: :destroy
  has_many :user_value_portraits, dependent: :destroy
  has_many :users, through: :user_value_portraits

  # Validations
  validates :key, presence: true, uniqueness: true,
            format: { with: /\A[a-z_]+\z/ }
  validates :name, presence: true
  validates :left_pole, :right_pole, presence: true
  validates :position, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position) }

  # Class methods
  def self.all_keys
    %w[
      liberty_authority
      economic_equality
      national_sovereignty
      tradition_progress
      environment_growth
      direct_representative
      secular_religious
      punitive_rehabilitative
    ]
  end
end
```

---

### Question Model

```ruby
# app/models/question.rb
class Question < ApplicationRecord
  # Associations
  belongs_to :value_dimension
  has_many :user_answers, dependent: :destroy

  # Validations
  validates :text, presence: true
  validates :question_type, presence: true,
            inclusion: { in: %w[direct_value policy_preference tradeoff dilemma] }
  validates :difficulty, inclusion: { in: %w[easy medium hard] }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :for_dimension, ->(dimension_id) { where(value_dimension_id: dimension_id) }
  scope :by_type, ->(type) { where(question_type: type) }
  scope :by_difficulty, ->(difficulty) { where(difficulty: difficulty) }
  scope :ordered, -> { order(:position) }

  # Instance methods
  def answered_by?(user)
    user_answers.exists?(user: user)
  end

  def answer_for(user)
    user_answers.find_by(user: user)
  end
end
```

---

### UserValuePortrait Model

```ruby
# app/models/user_value_portrait.rb
class UserValuePortrait < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :value_dimension

  # Validations
  validates :position, presence: true,
            numericality: { greater_than_or_equal_to: -1.0,
                          less_than_or_equal_to: 1.0 }
  validates :intensity, presence: true,
            numericality: { greater_than_or_equal_to: 0.0,
                          less_than_or_equal_to: 1.0 }
  validates :confidence, presence: true,
            numericality: { greater_than_or_equal_to: 0.0,
                          less_than_or_equal_to: 1.0 }
  validates :user_id, uniqueness: { scope: :value_dimension_id }

  # Scopes
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :recent, -> { order(last_calculated_at: :desc) }
  scope :stale, ->(days = 30) {
    where('last_calculated_at < ?', days.days.ago)
  }

  # Instance methods
  def position_label
    return value_dimension.left_pole if position < -0.3
    return value_dimension.right_pole if position > 0.3
    "Moderate"
  end

  def intensity_label
    return "Weak" if intensity < 0.3
    return "Strong" if intensity > 0.7
    "Moderate"
  end

  def needs_recalculation?
    last_calculated_at.nil? || last_calculated_at < 7.days.ago
  end
end
```

---

### UserAnswer Model

```ruby
# app/models/user_answer.rb
class UserAnswer < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :question

  # Validations
  validates :answer_data, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
  validate :answer_data_structure

  # Scopes
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :for_question, ->(question_id) { where(question_id: question_id) }
  scope :for_dimension, ->(dimension_id) {
    joins(:question).where(questions: { value_dimension_id: dimension_id })
  }
  scope :not_skipped, -> { where(skipped: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def value
    answer_data['value']
  end

  def normalized_value
    # Convert answer to -1 to +1 scale
    case question.question_type
    when 'direct_value'
      # 1-5 scale → -1 to +1
      ((value.to_f - 3) / 2.0).round(2)
    when 'policy_preference'
      # Binary → -1 or +1
      value == 'left' ? -1.0 : 1.0
    when 'tradeoff'
      # 0-100 slider → -1 to +1
      ((value.to_f - 50) / 50.0).round(2)
    when 'dilemma'
      # Choice A or B → -1 or +1
      value == 'A' ? -1.0 : 1.0
    end
  end

  private

  def answer_data_structure
    unless answer_data.is_a?(Hash) && answer_data['value'].present?
      errors.add(:answer_data, "must contain a 'value' key")
    end
  end
end
```

---

## Seed Data

### Value Dimensions Seed

```ruby
# db/seeds/value_dimensions.rb
dimensions = [
  {
    key: 'liberty_authority',
    name: 'Individual Liberty vs Collective Authority',
    description: 'The balance between individual freedom and collective governance',
    left_pole: 'Individual Liberty',
    right_pole: 'Collective Authority',
    position: 1
  },
  {
    key: 'economic_equality',
    name: 'Economic Equality vs Economic Hierarchy',
    description: 'The distribution of wealth and economic power',
    left_pole: 'Economic Equality',
    right_pole: 'Economic Hierarchy',
    position: 2
  },
  {
    key: 'national_sovereignty',
    name: 'National Sovereignty vs International Cooperation',
    description: 'The balance between national independence and global collaboration',
    left_pole: 'National Sovereignty',
    right_pole: 'International Cooperation',
    position: 3
  },
  {
    key: 'tradition_progress',
    name: 'Tradition vs Progress',
    description: 'The value placed on preserving traditions versus embracing change',
    left_pole: 'Tradition',
    right_pole: 'Progress',
    position: 4
  },
  {
    key: 'environment_growth',
    name: 'Environmental Protection vs Economic Growth',
    description: 'The priority given to environmental conservation versus economic development',
    left_pole: 'Environmental Protection',
    right_pole: 'Economic Growth',
    position: 5
  },
  {
    key: 'direct_representative',
    name: 'Direct Democracy vs Representative Democracy',
    description: 'The preferred method of democratic decision-making',
    left_pole: 'Direct Democracy',
    right_pole: 'Representative Democracy',
    position: 6
  },
  {
    key: 'secular_religious',
    name: 'Secularism vs Religious Values',
    description: 'The role of religion in public life and policy',
    left_pole: 'Secularism',
    right_pole: 'Religious Values',
    position: 7
  },
  {
    key: 'punitive_rehabilitative',
    name: 'Punitive Justice vs Rehabilitative Justice',
    description: 'The purpose and approach to criminal justice',
    left_pole: 'Punitive Justice',
    right_pole: 'Rehabilitative Justice',
    position: 8
  }
]

dimensions.each do |dim|
  ValueDimension.find_or_create_by!(key: dim[:key]) do |d|
    d.assign_attributes(dim)
  end
end

puts "✓ Created #{ValueDimension.count} value dimensions"
```

---
