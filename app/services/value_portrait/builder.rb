# frozen_string_literal: true

module ValuePortrait
  class Builder
    def initialize(user)
      @user = user
    end

    def build
      ValueDimension.active.find_each do |dimension|
        calculate_and_save_portrait(dimension)
      end
    end

    private

    attr_reader :user

    def calculate_and_save_portrait(dimension)
      answers = user.user_answers.joins(:question).where(questions: { value_dimension_id: dimension.id })
      return if answers.empty?

      position = calculate_position(answers, dimension)
      intensity = calculate_intensity(answers)
      confidence = calculate_confidence(answers, dimension)

      UserValuePortrait.find_or_initialize_by(user: user, value_dimension: dimension).tap do |portrait|
        portrait.position = position
        portrait.intensity = intensity
        portrait.confidence = confidence
        portrait.save!
      end
    end

    def calculate_position(answers, dimension)
      total_weight = 0
      weighted_sum = 0

      answers.each do |answer|
        question = answer.question
        weight = question_weight(question)
        normalized = answer.normalized_value

        # Convert 0-100 scale to -100 to 100 scale (centered at 0)
        position_value = (normalized - 50) * 2

        weighted_sum += position_value * weight
        total_weight += weight
      end

      return 0 if total_weight.zero?

      (weighted_sum / total_weight).round(2).clamp(-100, 100)
    end

    def calculate_intensity(answers)
      return 0 if answers.empty?

      # Intensity is based on how far from center (50) the answers are
      deviations = answers.map do |answer|
        (answer.normalized_value - 50).abs
      end

      average_deviation = deviations.sum / deviations.size.to_f
      # Scale to 0-100 where 50 (max deviation) = 100 intensity
      (average_deviation * 2).round(2).clamp(0, 100)
    end

    def calculate_confidence(answers, dimension)
      return 0 if answers.empty?

      # Get total questions for this dimension
      total_questions = Question.active.for_dimension(dimension).count
      return 0 if total_questions.zero?

      # Coverage: what percentage of questions were answered
      coverage = (answers.count.to_f / total_questions * 100).clamp(0, 100)

      # Consistency: how consistent are the answers (low standard deviation = high consistency)
      if answers.count > 1
        values = answers.map(&:normalized_value)
        mean = values.sum / values.size.to_f
        variance = values.map { |v| (v - mean)**2 }.sum / values.size
        std_dev = Math.sqrt(variance)
        # Convert std_dev (0-50 range) to consistency (100-0 range)
        consistency = ((50 - std_dev.clamp(0, 50)) / 50 * 100).round(2)
      else
        consistency = 50 # Neutral consistency for single answer
      end

      # Weighted average: 60% coverage, 40% consistency
      ((coverage * 0.6) + (consistency * 0.4)).round(2).clamp(0, 100)
    end

    def question_weight(question)
      # Higher difficulty questions get slightly more weight
      case question.difficulty_score
      when 5 then 1.5
      when 4 then 1.3
      when 3 then 1.0
      when 2 then 0.9
      else 0.8
      end
    end
  end
end
