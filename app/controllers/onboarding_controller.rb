class OnboardingController < ApplicationController
  COUNTRIES = ['United States', 'France', 'United Kingdom', 'Germany', 'Canada'].freeze

  def start
    # Reset session answers and show country selection
    session[:answers] = {}
    session[:user_profile] = {}
  end

  def save_profile
    session[:user_profile] = {
      country: params[:country],
      age: params[:age],
      gender: params[:gender],
      political_engagement: params[:political_engagement]
    }
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
    @portrait = calculate_portrait_from_session
  end

  private

  def available_questions
    country = session.dig(:user_profile, :country)
    if country.present?
      Question.active.for_country(country).ordered
    else
      Question.active.universal.ordered
    end
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
end
