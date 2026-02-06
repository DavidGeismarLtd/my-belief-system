class OnboardingController < ApplicationController
  COUNTRIES = [ "United States", "France", "United Kingdom", "Germany", "Canada" ].freeze

  def start
    # Reset session answers and show country selection
    session[:answers] = {}
    session[:user_profile] = {}
  end

  def save_profile
    # Save profile to session
    session[:user_profile] = {
      country: params[:country],
      age: params[:age],
      gender: params[:gender],
      political_engagement: params[:political_engagement]
    }

    # Update current user's profile
    current_user.update(
      country: params[:country],
      age: params[:age],
      gender: params[:gender],
      political_engagement: params[:political_engagement]
    )

    redirect_to onboarding_question_path(1)
  end

  def question
    @question_number = params[:number].to_i
    @questions = available_questions
    @total_questions = @questions.count
    @question = @questions[@question_number - 1]

    redirect_to onboarding_portrait_path if @question_number > @total_questions || @question.nil?
  end

  def answer
    question_number = params[:question_number].to_i
    answer_value = params[:answer_value]
    questions = available_questions
    question = questions[question_number - 1]

    # Store answer in session with question ID
    session[:answers] ||= {}
    session[:answers][question.id.to_s] = answer_value if question

    # Navigate to next question or portrait
    if question_number < questions.count
      redirect_to onboarding_question_path(question_number + 1)
    else
      redirect_to onboarding_portrait_path
    end
  end

  def portrait
    @answers = session[:answers] || {}

    # Use database portraits if available, otherwise calculate from session
    if current_user.user_value_portraits.any?
      @portrait = build_portrait_from_database
    else
      @portrait = calculate_portrait_from_session
    end
  end

  def complete
    # Save all session answers to database
    answers = session[:answers] || {}

    answers.each do |question_id, answer_value|
      # Skip if answer already exists
      next if current_user.user_answers.exists?(question_id: question_id)

      question = Question.find(question_id)
      normalized_value = normalize_answer_value(answer_value, question)

      current_user.user_answers.create!(
        question_id: question_id,
        answer_data: { value: normalized_value }
      )
    end

    # Update onboarding progress
    current_user.update_onboarding_progress!

    # Build value portraits from saved answers
    ValuePortrait::Builder.new(current_user).build

    # Clear session data
    session[:answers] = {}
    session[:user_profile] = {}

    # Redirect to dashboard
    redirect_to dashboard_path, notice: "Onboarding completed! Your value portrait has been created."
  end

  private

  def available_questions
    country = session.dig(:user_profile, :country) || current_user.country
    if country.present?
      Question.active.for_country(country).ordered
    else
      Question.active.universal.ordered
    end
  end

  def build_portrait_from_database
    dimensions = current_user.user_value_portraits.includes(:value_dimension).map do |portrait|
      dimension = portrait.value_dimension
      {
        name: dimension.name,
        position: portrait.position,
        intensity: portrait.intensity,
        confidence: portrait.confidence,
        left_pole: dimension.left_pole,
        right_pole: dimension.right_pole
      }
    end

    { dimensions: dimensions }
  end

  def calculate_portrait_from_session
    dimensions = ValueDimension.active.map do |dimension|
      # Get answers for this dimension from session
      dimension_questions = available_questions.where(value_dimension: dimension)
      answered_questions = dimension_questions.select { |q| session[:answers]&.key?(q.id.to_s) }

      if answered_questions.any?
        # Calculate position from answers
        total = 0
        answered_questions.each do |question|
          answer_value = session[:answers][question.id.to_s].to_f
          # Normalize to -100 to 100 scale
          normalized = (answer_value - 50) * 2
          total += normalized
        end
        position = (total / answered_questions.count).round(2)
        intensity = answered_questions.count > 1 ? rand(60..90) : 50
        confidence = (answered_questions.count.to_f / dimension_questions.count * 100).round(2)
      else
        position = 0
        intensity = 0
        confidence = 0
      end

      {
        name: dimension.name,
        position: position,
        intensity: intensity,
        confidence: confidence,
        left_pole: dimension.left_pole,
        right_pole: dimension.right_pole
      }
    end

    { dimensions: dimensions }
  end

  def normalize_answer_value(value, question)
    # Convert string values to appropriate types based on question type
    case question.question_type
    when "direct_value"
      # Convert to integer (1-5)
      value.to_i
    when "tradeoff_slider"
      # Convert to integer (0-100)
      value.to_i
    when "policy_preference"
      # Keep as string ('left' or 'right')
      value.to_s
    when "dilemma"
      # Keep as string ('A' or 'B')
      value.to_s
    else
      value
    end
  end
end
