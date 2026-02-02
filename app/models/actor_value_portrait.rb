class ActorValuePortrait < ApplicationRecord
  # Associations
  belongs_to :actor
  belongs_to :value_dimension

  # Validations
  validates :actor_id, uniqueness: { scope: :value_dimension_id }
  validates :position, presence: true, numericality: {
    greater_than_or_equal_to: -100,
    less_than_or_equal_to: 100
  }
  validates :intensity, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
    allow_nil: true
  }
  validates :confidence, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
    allow_nil: true
  }

  # Scopes
  scope :high_confidence, -> { where('confidence >= ?', 70) }
  scope :low_confidence, -> { where('confidence < ?', 50) }
  scope :strong_position, -> { where('ABS(position) >= ?', 50) }
  scope :moderate_position, -> { where('ABS(position) < ?', 50) }

  # Instance Methods
  def left_leaning?
    position < 0
  end

  def right_leaning?
    position > 0
  end

  def centrist?
    position.abs < 20
  end

  def strong?
    position.abs >= 50
  end

  def moderate?
    position.abs < 50 && position.abs >= 20
  end

  def high_confidence?
    confidence.present? && confidence >= 70
  end

  def low_confidence?
    confidence.present? && confidence < 50
  end
end

