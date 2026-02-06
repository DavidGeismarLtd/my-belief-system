class UserAnswer < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :question

  # Validations
  validates :user_id, uniqueness: { scope: :question_id, message: "has already answered this question" }
  validates :answer_data, presence: true
  validate :answer_data_has_value
  validate :answer_value_is_valid

  # Callbacks
  after_create :update_user_onboarding_progress

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_dimension, ->(dimension_id) {
    joins(:question).where(questions: { value_dimension_id: dimension_id })
  }
  scope :by_question_type, ->(type) {
    joins(:question).where(questions: { question_type: type })
  }

  # Instance Methods
  def value
    answer_data["value"]
  end

  def time_spent
    answer_data["time_spent_seconds"]
  end

  def normalized_value
    # Normalize answer to -100 to 100 scale based on question type
    case question.question_type
    when "direct_value"
      # Scale: 1-5 -> -100 to 100
      ((value - 3) * 50.0).round(2)
    when "policy_preference"
      # left/right -> -100/100
      value == "left" ? -100 : 100
    when "tradeoff_slider"
      # 0-100 -> -100 to 100
      ((value - 50) * 2.0).round(2)
    when "dilemma"
      # A/B -> -100/100
      value == "A" ? -100 : 100
    else
      0
    end
  end

  def to_s
    "#{user.email} answered Q#{question.id}: #{value}"
  end

  private

  def answer_data_has_value
    if answer_data.blank? || !answer_data.key?("value")
      errors.add(:answer_data, "must contain a 'value' key")
    end
  end

  def answer_value_is_valid
    return if answer_data.blank? || !answer_data.key?("value")

    case question&.question_type
    when "direct_value"
      unless value.is_a?(Integer) && value.between?(1, 5)
        errors.add(:answer_data, "value must be an integer between 1 and 5 for direct_value questions")
      end
    when "policy_preference"
      unless %w[left right].include?(value)
        errors.add(:answer_data, "value must be 'left' or 'right' for policy_preference questions")
      end
    when "tradeoff_slider"
      unless value.is_a?(Integer) && value.between?(0, 100)
        errors.add(:answer_data, "value must be an integer between 0 and 100 for tradeoff_slider questions")
      end
    when "dilemma"
      unless %w[A B].include?(value)
        errors.add(:answer_data, "value must be 'A' or 'B' for dilemma questions")
      end
    end
  end

  def update_user_onboarding_progress
    user.update_onboarding_progress!
  end
end
