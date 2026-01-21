class DashboardController < ApplicationController
  def index
    @actors = Actor.active.map do |actor|
      {
        id: actor.id,
        name: actor.name,
        type: actor.actor_type.capitalize,
        location: actor.country || "National",
        role: actor.role,
        party: actor.party_affiliation,
        image_url: actor.image_url,
        alignment_score: calculate_mock_alignment_score,
        alignment_label: alignment_label(calculate_mock_alignment_score),
        alignment_color: alignment_color(calculate_mock_alignment_score),
        strong_dimensions: sample_dimensions(2),
        weak_dimensions: sample_dimensions(1),
        trend: %w[up down stable].sample,
        trend_value: rand(0.01..0.15).round(2)
      }
    end
  end

  private

  def calculate_mock_alignment_score
    rand(20..85)
  end

  def alignment_label(score)
    case score
    when 80..100 then "Strong"
    when 60..79 then "Moderate"
    when 40..59 then "Weak"
    else "Misalignment"
    end
  end

  def alignment_color(score)
    case score
    when 80..100 then "green"
    when 60..79 then "blue"
    when 40..59 then "amber"
    else "red"
    end
  end

  def sample_dimensions(count)
    ValueDimension.active.sample(count).map(&:name)
  end
end
