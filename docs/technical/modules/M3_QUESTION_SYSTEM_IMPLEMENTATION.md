# Module 3: Question System - Implementation Details

This is a continuation of M3_QUESTION_SYSTEM.md

---

## Implementation Details

### 1. Questions Controller

```ruby
# app/controllers/api/v1/questions_controller.rb
module Api
  module V1
    class QuestionsController < ApplicationController
      def index
        batch_size = params[:batch_size]&.to_i || 1
        
        questions = QuestionSelectionService.new(current_user).next_questions(batch_size)
        
        if questions.empty?
          render json: {
            status: 'error',
            message: 'No more questions available'
          }, status: :not_found
          return
        end
        
        render json: {
          status: 'success',
          data: {
            questions: questions.map { |q| QuestionSerializer.new(q).as_json },
            progress: ProgressCalculator.new(current_user).calculate,
            onboarding_complete: current_user.onboarding_completed
          }
        }, status: :ok
      end
    end
  end
end
```

---

### 2. Answers Controller

```ruby
# app/controllers/api/v1/answers_controller.rb
module Api
  module V1
    class AnswersController < ApplicationController
      def create
        answer = current_user.user_answers.build(answer_params)
        
        if answer.save
          # Update onboarding progress
          UpdateOnboardingProgressService.new(current_user).call
          
          render json: {
            status: 'success',
            message: 'Answer recorded successfully',
            data: {
              answer: AnswerSerializer.new(answer).as_json,
              progress: ProgressCalculator.new(current_user).calculate
            }
          }, status: :created
        else
          render json: {
            status: 'error',
            message: 'Answer validation failed',
            errors: answer.errors.messages
          }, status: :unprocessable_entity
        end
      end
      
      def skip
        result = SkipQuestionService.new(current_user, params[:question_id]).call
        
        if result[:success]
          render json: {
            status: 'success',
            message: 'Question skipped',
            data: {
              skips_remaining: result[:skips_remaining],
              progress: ProgressCalculator.new(current_user).calculate
            }
          }, status: :ok
        else
          render json: {
            status: 'error',
            message: result[:error]
          }, status: :unprocessable_entity
        end
      end
      
      private
      
      def answer_params
        params.require(:answer).permit(:question_id, answer_data: {})
      end
    end
  end
end
```

---

### 3. Onboarding Controller

```ruby
# app/controllers/api/v1/onboarding_controller.rb
module Api
  module V1
    class OnboardingController < ApplicationController
      def progress
        calculator = ProgressCalculator.new(current_user)
        
        render json: {
          status: 'success',
          data: {
            progress: calculator.calculate,
            by_dimension: calculator.by_dimension,
            onboarding_complete: current_user.onboarding_completed,
            estimated_time_remaining: calculator.estimated_time_remaining
          }
        }, status: :ok
      end
    end
  end
end
```

---

### 4. Question Selection Service

```ruby
# app/services/question_selection_service.rb
class QuestionSelectionService
  MAX_SKIPS = 3
  MIN_QUESTIONS_PER_DIMENSION = 3
  
  def initialize(user)
    @user = user
  end
  
  def next_questions(batch_size = 1)
    # Get questions user hasn't answered or skipped
    available_questions = Question.active
      .where.not(id: answered_question_ids)
      .where.not(id: skipped_question_ids)
    
    # Prioritize dimensions with fewer answers
    prioritized_questions = prioritize_by_dimension(available_questions)
    
    # Apply adaptive algorithm
    selected_questions = apply_adaptive_algorithm(prioritized_questions, batch_size)
    
    selected_questions.limit(batch_size)
  end
  
  private
  
  def answered_question_ids
    @user.user_answers.pluck(:question_id)
  end
  
  def skipped_question_ids
    @user.skipped_questions || []
  end
  
  def prioritize_by_dimension(questions)
    # Count answers per dimension
    dimension_counts = @user.user_answers
      .joins(:question)
      .group('questions.value_dimension_id')
      .count
    
    # Sort questions by dimension with fewest answers
    questions.sort_by do |question|
      [
        dimension_counts[question.value_dimension_id] || 0,
        question.difficulty_score,
        question.position
      ]
    end
  end
  
  def apply_adaptive_algorithm(questions, batch_size)
    # Simple adaptive algorithm for MVP
    # Prioritize questions that maximize information gain
    
    selected = []
    dimensions_covered = Set.new
    
    questions.each do |question|
      break if selected.size >= batch_size
      
      # Prefer questions from uncovered dimensions
      if !dimensions_covered.include?(question.value_dimension_id)
        selected << question
        dimensions_covered << question.value_dimension_id
      elsif selected.size < batch_size
        selected << question
      end
    end
    
    Question.where(id: selected.map(&:id))
  end
end
```

---


