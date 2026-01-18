class Question < ApplicationRecord
  # Constants
  QUESTION_TYPES = %w[direct_value policy_preference tradeoff_slider dilemma].freeze

  # Associations
  belongs_to :value_dimension
  has_many :user_answers, dependent: :destroy
  has_many :users, through: :user_answers

  # Validations
  validates :text, presence: true
  validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :difficulty_score, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc) }
  scope :by_type, ->(type) { where(question_type: type) }
  scope :for_dimension, ->(dimension_id) { where(value_dimension_id: dimension_id) }
  scope :for_country, ->(country) { where("country = ? OR is_universal = ?", country, true) }
  scope :universal, -> { where(is_universal: true) }
  scope :country_specific, -> { where(is_universal: false) }
  scope :easy, -> { where(difficulty_score: 1..2) }
  scope :medium, -> { where(difficulty_score: 3) }
  scope :hard, -> { where(difficulty_score: 4..5) }

  # Instance Methods
  def answer_count
    user_answers.count
  end

  def average_answer_value
    return nil unless user_answers.any?

    values = user_answers.map { |a| a.answer_data['value'] }.compact
    return nil if values.empty?

    values.sum.to_f / values.size
  end

  def difficulty_label
    case difficulty_score
    when 1..2 then 'easy'
    when 3 then 'medium'
    when 4..5 then 'hard'
    else 'unknown'
    end
  end

  def direct_value?
    question_type == 'direct_value'
  end

  def policy_preference?
    question_type == 'policy_preference'
  end

  def tradeoff_slider?
    question_type == 'tradeoff_slider'
  end

  def dilemma?
    question_type == 'dilemma'
  end

  def to_s
    text.truncate(50)
  end
end
