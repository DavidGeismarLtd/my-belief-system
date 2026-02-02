class ActorsController < ApplicationController
  def index
    @actors = Actor.active.order(:name).map do |actor|
      {
        id: actor.id,
        name: actor.name,
        type: actor.display_type,
        location: actor.country,
        role: actor.role,
        party: actor.party_affiliation
      }
    end
  end

  def show
    actor = Actor.find_by(id: params[:id])

    if actor.nil?
      redirect_to actors_path, alert: "Actor not found"
      return
    end

    @actor = build_actor_detail(actor)
    @user_portrait = build_user_portrait
  end

  private

  def build_actor_detail(actor)
    {
      id: actor.id,
      name: actor.name,
      type: actor.display_type,
      location: actor.country,
      role: actor.role,
      party: actor.party_affiliation,
      description: actor.description,
      program_url: actor.program_url,
      image_url: actor.avatar_url,
      alignment_score: calculate_overall_alignment(actor),
      dimensions: build_dimension_comparisons(actor),
      interventions: actor.personality? ? build_interventions(actor) : nil
    }.compact
  end

  def build_interventions(actor)
    actor.recent_interventions(5).map do |intervention|
      {
        type: intervention.intervention_type,
        platform: intervention.source_platform,
        content: intervention.content,
        published_at: intervention.published_at,
        source_url: intervention.source_url
      }
    end
  end

  def build_dimension_comparisons(actor)
    user_portraits = current_user.user_value_portraits.includes(:value_dimension)
    actor_positions = get_actor_positions(actor)

    ValueDimension.active.ordered.map do |dimension|
      user_portrait = user_portraits.find { |p| p.value_dimension_id == dimension.id }
      actor_position = actor_positions[dimension.id] || 0

      user_position = user_portrait&.position || 0
      alignment = calculate_dimension_alignment(user_position, actor_position)

      {
        name: dimension.name,
        actor_position: actor_position.round,
        user_position: user_position.round,
        alignment: alignment
      }
    end
  end

  def build_user_portrait
    user_portraits = current_user.user_value_portraits.includes(:value_dimension)

    {
      dimensions: ValueDimension.active.ordered.map do |dimension|
        portrait = user_portraits.find { |p| p.value_dimension_id == dimension.id }
        {
          name: dimension.name,
          position: portrait&.position&.round || 0
        }
      end
    }
  end

  def calculate_overall_alignment(actor)
    user_portraits = current_user.user_value_portraits.includes(:value_dimension)
    return 50 if user_portraits.empty?

    actor_positions = get_actor_positions(actor)
    total_weighted_alignment = 0
    total_weight = 0

    user_portraits.each do |user_portrait|
      actor_position = actor_positions[user_portrait.value_dimension_id] || 0
      alignment = calculate_dimension_alignment(user_portrait.position, actor_position)

      # Weight by user's intensity and confidence
      weight = (user_portrait.intensity || 50) * (user_portrait.confidence || 50) / 100.0
      total_weighted_alignment += alignment * weight
      total_weight += weight
    end

    return 50 if total_weight.zero?
    (total_weighted_alignment / total_weight).round
  end

  def calculate_dimension_alignment(user_position, actor_position)
    # Alignment formula: 1 - (|user_position - actor_position| / 200) * 100
    # Positions are on -100 to 100 scale, so max difference is 200
    difference = (user_position - actor_position).abs
    alignment = (1 - (difference / 200.0)) * 100
    alignment.round.clamp(0, 100)
  end

  def get_actor_positions(actor)
    # Get positions from ActorValuePortrait model
    actor_portraits = actor.actor_value_portraits.includes(:value_dimension)

    # Build hash of dimension_id => position
    positions = {}
    actor_portraits.each do |portrait|
      positions[portrait.value_dimension_id] = portrait.position
    end

    # Fallback to metadata if no portraits exist (for backward compatibility during migration)
    if positions.empty? && actor.metadata['value_positions'].present?
      positions = actor.metadata['value_positions'].transform_keys do |key|
        key.is_a?(String) ? key.to_i : key
      end
    end

    positions
  end
end
