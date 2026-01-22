class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Associations
  has_many :user_answers, dependent: :destroy
  has_many :answered_questions, through: :user_answers, source: :question
  has_many :user_value_portraits, dependent: :destroy
  has_many :value_dimensions, through: :user_value_portraits

  # Validations
  validates :name, length: { maximum: 100 }
  validates :onboarding_progress, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validates :country, presence: true, if: :onboarding_completed?
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 150 }, allow_nil: true

  # Callbacks
  before_save :downcase_email

  # Scopes
  scope :onboarding_completed, -> { where(onboarding_completed: true) }
  scope :onboarding_incomplete, -> { where(onboarding_completed: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance Methods
  def portrait_complete?
    user_value_portraits.count >= ValueDimension.active.count
  end

  def answered_question_count
    user_answers.count
  end

  def skipped_question_count
    (skipped_questions || []).size
  end

  def can_skip_question?
    skipped_question_count < 3
  end

  def skip_question!(question_id)
    return false unless can_skip_question?

    self.skipped_questions ||= []
    self.skipped_questions << question_id unless skipped_questions.include?(question_id)
    save
  end

  def update_onboarding_progress!
    total_questions = Question.active.count
    answered = user_answers.count

    self.onboarding_progress = ((answered.to_f / total_questions) * 100).round
    self.onboarding_completed = (onboarding_progress >= 100)
    save
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
