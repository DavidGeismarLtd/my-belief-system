class Intervention < ApplicationRecord
  # Constants
  INTERVENTION_TYPES = %w[tweet video declaration speech article interview].freeze
  PLATFORMS = %w[twitter youtube facebook instagram press_release website other].freeze
  
  # Associations
  belongs_to :actor
  
  # Validations
  validates :intervention_type, presence: true, inclusion: { in: INTERVENTION_TYPES }
  validates :content, presence: true
  validates :published_at, presence: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(published_at: :desc) }
  scope :by_type, ->(type) { where(intervention_type: type) }
  scope :by_platform, ->(platform) { where(source_platform: platform) }
  scope :tweets, -> { where(intervention_type: 'tweet') }
  scope :videos, -> { where(intervention_type: 'video') }
  scope :declarations, -> { where(intervention_type: 'declaration') }
  
  # Instance Methods
  def tweet?
    intervention_type == 'tweet'
  end
  
  def video?
    intervention_type == 'video'
  end
  
  def declaration?
    intervention_type == 'declaration'
  end
  
  def platform_icon
    case source_platform
    when 'twitter' then '𝕏'
    when 'youtube' then '▶'
    when 'facebook' then 'f'
    when 'instagram' then '📷'
    when 'press_release' then '📰'
    else '🔗'
    end
  end
  
  def short_content(length = 200)
    content.truncate(length)
  end
end

