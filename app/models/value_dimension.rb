class ValueDimension < ApplicationRecord
  # Associations
  has_many :questions, dependent: :destroy
  has_many :user_value_portraits, dependent: :destroy
  has_many :users, through: :user_value_portraits
  has_many :actor_value_portraits, dependent: :destroy
  has_many :actors, through: :actor_value_portraits

  # Validations
  validates :key, presence: true, uniqueness: true
  validates :key, format: { with: /\A[a-z_]+\z/, message: "only allows lowercase letters and underscores" }
  validates :name, presence: true
  validates :left_pole, presence: true
  validates :right_pole, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc) }
  scope :with_questions, -> { joins(:questions).distinct }

  # Instance Methods
  def question_count
    questions.active.count
  end

  def user_count
    users.distinct.count
  end

  def average_position
    user_value_portraits.average(:position)
  end

  def display_name
    name
  end

  def poles
    [left_pole, right_pole]
  end

  def to_s
    name
  end
end
