# Module 2: Authentication & User Management

**Timeline**: Weeks 3-4
**Owner**: Backend Lead
**Team**: 1 Backend Engineer
**Dependencies**: Module 1 (Database Foundation)
**Blocks**: Modules 3, 4, 7

---

## Module Overview

This module implements user authentication and authorization for the First Principles MVP using Devise for authentication and JWT tokens for API access. It includes user registration, login/logout, password reset, and basic authorization with Pundit.

**Success Criteria**:
- Users can register with email/password
- Users can login and receive JWT token
- JWT tokens authenticate API requests
- Password reset flow works
- Security audit passed (OWASP Top 10)
- All auth tests passing (>90% coverage)

---

## Technical Specifications

### API Endpoints

#### 1. User Registration

**Endpoint**: `POST /api/v1/auth/register`

**Request Body**:
```json
{
  "user": {
    "email": "user@example.com",
    "password": "SecurePass123!",
    "password_confirmation": "SecurePass123!",
    "name": "John Doe"
  }
}
```

**Success Response** (201 Created):
```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe",
      "onboarding_completed": false,
      "created_at": "2026-01-15T10:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

**Error Response** (422 Unprocessable Entity):
```json
{
  "status": "error",
  "message": "Registration failed",
  "errors": {
    "email": ["has already been taken"],
    "password": ["is too short (minimum is 8 characters)"]
  }
}
```

**Validations**:
- Email: Required, valid format, unique
- Password: Required, minimum 8 characters, must include uppercase, lowercase, number
- Password confirmation: Must match password
- Name: Optional, max 100 characters

---

#### 2. User Login

**Endpoint**: `POST /api/v1/auth/login`

**Request Body**:
```json
{
  "user": {
    "email": "user@example.com",
    "password": "SecurePass123!"
  }
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Logged in successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe",
      "onboarding_completed": true,
      "last_sign_in_at": "2026-01-15T10:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

**Error Response** (401 Unauthorized):
```json
{
  "status": "error",
  "message": "Invalid email or password"
}
```

---

#### 3. User Logout

**Endpoint**: `DELETE /api/v1/auth/logout`

**Headers**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Logged out successfully"
}
```

---

#### 4. Get Current User

**Endpoint**: `GET /api/v1/auth/me`

**Headers**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe",
      "onboarding_completed": true,
      "onboarding_progress": 100,
      "portrait_complete": true,
      "created_at": "2026-01-15T10:00:00Z"
    }
  }
}
```

**Error Response** (401 Unauthorized):
```json
{
  "status": "error",
  "message": "Invalid or expired token"
}
```

---

#### 5. Password Reset Request

**Endpoint**: `POST /api/v1/auth/password/reset`

**Request Body**:
```json
{
  "user": {
    "email": "user@example.com"
  }
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Password reset instructions sent to your email"
}
```

**Note**: Always returns success even if email doesn't exist (security best practice)

---

#### 6. Password Reset Confirmation

**Endpoint**: `PUT /api/v1/auth/password/reset`

**Request Body**:
```json
{
  "user": {
    "reset_password_token": "abc123...",
    "password": "NewSecurePass123!",
    "password_confirmation": "NewSecurePass123!"
  }
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Password reset successfully"
}
```

---

## Implementation Details

### 1. Devise Setup

```ruby
# Gemfile
gem 'devise'
gem 'devise-jwt'

# config/initializers/devise.rb
Devise.setup do |config|
  config.mailer_sender = 'noreply@firstprinciples.app'
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  # JWT configuration
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key
    jwt.dispatch_requests = [
      ['POST', %r{^/api/v1/auth/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/v1/auth/logout$}]
    ]
    jwt.expiration_time = 24.hours.to_i
  end
end
```

### 2. Gemfile Dependencies

```ruby
# Gemfile
gem 'devise', '~> 4.9'
gem 'jwt', '~> 2.7'
gem 'bcrypt', '~> 3.1.7'
gem 'pundit', '~> 2.3'
gem 'rack-cors', '~> 2.0'
```

---

### 3. Controllers

#### Auth::RegistrationsController

```ruby
# app/controllers/api/v1/auth/registrations_controller.rb
module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        skip_before_action :authenticate_user!

        def create
          user = User.new(registration_params)

          if user.save
            token = JwtService.encode(user_id: user.id)
            render json: {
              status: 'success',
              message: 'User registered successfully',
              data: {
                user: UserSerializer.new(user).as_json,
                token: token
              }
            }, status: :created
          else
            render json: {
              status: 'error',
              message: 'Registration failed',
              errors: user.errors.messages
            }, status: :unprocessable_entity
          end
        end

        private

        def registration_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
```

---

#### Auth::SessionsController

```ruby
# app/controllers/api/v1/auth/sessions_controller.rb
module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        skip_before_action :authenticate_user!, only: [:create]

        def create
          user = User.find_by(email: login_params[:email])

          if user&.valid_password?(login_params[:password])
            user.update(
              sign_in_count: user.sign_in_count + 1,
              current_sign_in_at: Time.current,
              last_sign_in_at: user.current_sign_in_at,
              current_sign_in_ip: request.remote_ip,
              last_sign_in_ip: user.current_sign_in_ip
            )

            token = JwtService.encode(user_id: user.id)
            render json: {
              status: 'success',
              message: 'Logged in successfully',
              data: {
                user: UserSerializer.new(user).as_json,
                token: token
              }
            }, status: :ok
          else
            render json: {
              status: 'error',
              message: 'Invalid email or password'
            }, status: :unauthorized
          end
        end

        def destroy
          render json: {
            status: 'success',
            message: 'Logged out successfully'
          }, status: :ok
        end

        private

        def login_params
          params.require(:user).permit(:email, :password)
        end
      end
    end
  end
end
```

---

#### Auth::UsersController

```ruby
# app/controllers/api/v1/auth/users_controller.rb
module Api
  module V1
    module Auth
      class UsersController < ApplicationController
        def show
          render json: {
            status: 'success',
            data: {
              user: UserSerializer.new(current_user).as_json
            }
          }, status: :ok
        end
      end
    end
  end
end
```

---

#### Auth::PasswordsController

```ruby
# app/controllers/api/v1/auth/passwords_controller.rb
module Api
  module V1
    module Auth
      class PasswordsController < ApplicationController
        skip_before_action :authenticate_user!

        def create
          user = User.find_by(email: password_reset_params[:email])

          if user
            user.send_reset_password_instructions
          end

          # Always return success (security best practice)
          render json: {
            status: 'success',
            message: 'Password reset instructions sent to your email'
          }, status: :ok
        end

        def update
          user = User.reset_password_by_token(password_update_params)

          if user.errors.empty?
            render json: {
              status: 'success',
              message: 'Password reset successfully'
            }, status: :ok
          else
            render json: {
              status: 'error',
              message: 'Password reset failed',
              errors: user.errors.messages
            }, status: :unprocessable_entity
          end
        end

        private

        def password_reset_params
          params.require(:user).permit(:email)
        end

        def password_update_params
          params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
        end
      end
    end
  end
end
```

---
