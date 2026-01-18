class OnboardingController < ApplicationController
  TOTAL_QUESTIONS = 24
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
    @total_questions = TOTAL_QUESTIONS
    @question = mock_question(@question_number)

    redirect_to onboarding_portrait_path if @question_number > TOTAL_QUESTIONS
  end

  def answer
    question_number = params[:question_number].to_i
    answer_value = params[:answer_value]

    # Store answer in session
    session[:answers] ||= {}
    session[:answers][question_number.to_s] = answer_value

    # Navigate to next question or portrait
    if question_number < TOTAL_QUESTIONS
      redirect_to onboarding_question_path(question_number + 1)
    else
      redirect_to onboarding_portrait_path
    end
  end

  def portrait
    @answers = session[:answers] || {}
    @portrait = calculate_mock_portrait(@answers)
  end

  private

  def mock_question(number)
    questions = [
      {
        number: 1,
        text: "Should the government provide universal healthcare, or should healthcare be primarily private?",
        type: "multiple_choice",
        options: [
          "Government-run universal healthcare",
          "Government option + private market",
          "Primarily private healthcare",
          "I'm not sure"
        ]
      },
      {
        number: 2,
        text: "How important is individual freedom compared to collective security?",
        type: "slider",
        left_label: "Individual Freedom",
        right_label: "Collective Security"
      },
      {
        number: 3,
        text: "Should taxes on the wealthy be increased to fund social programs?",
        type: "multiple_choice",
        options: [
          "Yes, significantly increase",
          "Yes, moderately increase",
          "Keep current levels",
          "No, decrease taxes",
          "I'm not sure"
        ]
      },
      {
        number: 4,
        text: "How important is environmental protection compared to economic growth?",
        type: "slider",
        left_label: "Environmental Protection",
        right_label: "Economic Growth"
      },
      {
        number: 5,
        text: "Should immigration be more restricted or more open?",
        type: "multiple_choice",
        options: [
          "Much more open",
          "Somewhat more open",
          "Keep current levels",
          "Somewhat more restricted",
          "Much more restricted",
          "I'm not sure"
        ]
      }
    ]

    # Repeat pattern for 24 questions
    base_question = questions[(number - 1) % questions.length]
    base_question.merge(number: number)
  end

  def calculate_mock_portrait(answers)
    # Mock calculation - in reality this would use the ValuePortrait::Calculator service
    {
      dimensions: [
        {
          name: "Individual Liberty vs Collective Authority",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Individual Liberty",
          right_pole: "Collective Authority"
        },
        {
          name: "Economic Equality vs Free Market",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Economic Equality",
          right_pole: "Free Market"
        },
        {
          name: "Environmental Protection vs Economic Growth",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Environmental Protection",
          right_pole: "Economic Growth"
        },
        {
          name: "National Sovereignty vs Global Cooperation",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "National Sovereignty",
          right_pole: "Global Cooperation"
        },
        {
          name: "Traditional Values vs Progressive Values",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Traditional Values",
          right_pole: "Progressive Values"
        },
        {
          name: "Law & Order vs Criminal Justice Reform",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Law & Order",
          right_pole: "Criminal Justice Reform"
        },
        {
          name: "Direct Democracy vs Representative Democracy",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Direct Democracy",
          right_pole: "Representative Democracy"
        },
        {
          name: "Meritocracy vs Equal Outcomes",
          position: rand(-80..80),
          intensity: rand(50..100),
          confidence: rand(60..95),
          left_pole: "Meritocracy",
          right_pole: "Equal Outcomes"
        }
      ]
    }
  end
end
