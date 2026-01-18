class Actor < ApplicationRecord
  # Constants
  ACTOR_TYPES = %w[party personality organization].freeze
  
  # Associations
  has_many :interventions, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :actor_type, presence: true, inclusion: { in: ACTOR_TYPES }
  validates :country, presence: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :by_country, ->(country) { where(country: country) }
  scope :parties, -> { where(actor_type: 'party') }
  scope :personalities, -> { where(actor_type: 'personality') }
  scope :organizations, -> { where(actor_type: 'organization') }
  scope :recent, -> { order(created_at: :desc) }
  
  # Instance Methods
  def party?
    actor_type == 'party'
  end
  
  def personality?
    actor_type == 'personality'
  end
  
  def organization?
    actor_type == 'organization'
  end
  
  def recent_interventions(limit = 10)
    interventions.active.order(published_at: :desc).limit(limit)
  end
  
  def avatar_url
    image_url.presence || default_avatar_url
  end
  
  private
  
  def default_avatar_url
    # Placeholder avatar based on actor type
    case actor_type
    when 'party'
      'https://ui-avatars.com/api/?name=' + CGI.escape(name) + '&background=3B82F6&color=fff&size=200'
    when 'personality'
      'https://ui-avatars.com/api/?name=' + CGI.escape(name) + '&background=10B981&color=fff&size=200'
    when 'organization'
      'https://ui-avatars.com/api/?name=' + CGI.escape(name) + '&background=8B5CF6&color=fff&size=200'
    end
  end
end

