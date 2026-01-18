# Module 2: Authentication - Part 2
## Services, Serializers, Routes, and Testing

This is a continuation of M2_AUTHENTICATION.md

---

## 4. JWT Service

```ruby
# app/services/jwt_service.rb
class JwtService
  SECRET_KEY = Rails.application.credentials.devise_jwt_secret_key
  
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
  
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    Rails.logger.error("JWT decode error: #{e.message}")
    nil
  end
  
  def self.valid_token?(token)
    decode(token).present?
  end
end
```

---

## 5. Application Controller

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :authenticate_user!
  
  attr_reader :current_user
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
  
  def authenticate_user!
    token = extract_token_from_header
    
    if token.blank?
      render_unauthorized('Missing authentication token')
      return
    end
    
    decoded = JwtService.decode(token)
    
    if decoded.nil?
      render_unauthorized('Invalid or expired token')
      return
    end
    
    @current_user = User.find_by(id: decoded[:user_id])
    
    if @current_user.nil?
      render_unauthorized('User not found')
    end
  end
  
  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end
  
  def render_unauthorized(message = 'Unauthorized')
    render json: {
      status: 'error',
      message: message
    }, status: :unauthorized
  end
  
  def user_not_authorized
    render json: {
      status: 'error',
      message: 'You are not authorized to perform this action'
    }, status: :forbidden
  end
end
```

---

## 6. User Serializer

```ruby
# app/serializers/user_serializer.rb
class UserSerializer
  def initialize(user)
    @user = user
  end
  
  def as_json
    {
      id: @user.id,
      email: @user.email,
      name: @user.name,
      onboarding_completed: @user.onboarding_completed,
      onboarding_progress: @user.onboarding_progress,
      portrait_complete: @user.portrait_complete?,
      created_at: @user.created_at.iso8601,
      last_sign_in_at: @user.last_sign_in_at&.iso8601
    }
  end
end
```

---

## 7. Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        # Registration
        post 'register', to: 'registrations#create'
        
        # Sessions
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
        
        # Current user
        get 'me', to: 'users#show'
        
        # Password reset
        post 'password/reset', to: 'passwords#create'
        put 'password/reset', to: 'passwords#update'
      end
    end
  end
end
```

---

## 8. CORS Configuration

```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('ALLOWED_ORIGINS', 'http://localhost:3000').split(',')
    
    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Authorization']
  end
end
```

---

## 9. Credentials Setup

```bash
# Generate secret key
rails secret

# Edit credentials
EDITOR="code --wait" rails credentials:edit

# Add to credentials:
devise_jwt_secret_key: <generated_secret_key>
```

---

## Product Specifications

### User Stories

**US-2.1: User Registration**
- **As a** new user
- **I want to** register with email and password
- **So that** I can create an account and access the platform

**Acceptance Criteria**:
- ✅ User can register with valid email and password
- ✅ Password must be at least 8 characters
- ✅ Password must include uppercase, lowercase, and number
- ✅ Email must be unique
- ✅ User receives JWT token upon successful registration
- ✅ Appropriate error messages for validation failures

---

**US-2.2: User Login**
- **As a** registered user
- **I want to** login with my credentials
- **So that** I can access my account

**Acceptance Criteria**:
- ✅ User can login with valid email/password
- ✅ User receives JWT token upon successful login
- ✅ Invalid credentials return 401 error
- ✅ Sign-in tracking updated (count, timestamps, IP)
- ✅ Token expires after 24 hours

---

**US-2.3: Password Reset**
- **As a** user who forgot my password
- **I want to** reset my password via email
- **So that** I can regain access to my account

**Acceptance Criteria**:
- ✅ User can request password reset with email
- ✅ Reset email sent within 1 minute
- ✅ Reset link expires after 6 hours
- ✅ User can set new password with valid token
- ✅ System doesn't reveal if email exists (security)

---

**US-2.4: Protected Routes**
- **As a** system
- **I want to** protect API endpoints with authentication
- **So that** only authenticated users can access them

**Acceptance Criteria**:
- ✅ All API endpoints require valid JWT token (except auth endpoints)
- ✅ Invalid/missing token returns 401 error
- ✅ Expired token returns 401 error
- ✅ Token extracted from Authorization header

---

### Edge Cases

1. **Concurrent Registrations**: Same email registered simultaneously
   - **Handling**: Database unique constraint prevents duplicates

2. **Token Expiration During Request**: Token expires mid-session
   - **Handling**: Return 401, frontend refreshes token or redirects to login

3. **Password Reset Token Reuse**: User tries to use same reset token twice
   - **Handling**: Token invalidated after first use

4. **Brute Force Login Attempts**: Multiple failed login attempts
   - **Handling**: Rate limiting (to be implemented in production)

5. **Special Characters in Password**: User includes special chars
   - **Handling**: BCrypt handles all characters safely

---

## Testing Strategy

### Unit Tests

```ruby
# spec/services/jwt_service_spec.rb
require 'rails_helper'

RSpec.describe JwtService do
  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload)
      
      expect(token).to be_present
      expect(token).to be_a(String)
    end
    
    it 'includes expiration time' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload)
      decoded = JwtService.decode(token)
      
      expect(decoded[:exp]).to be_present
    end
  end
  
  describe '.decode' do
    it 'decodes a valid token' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload)
      decoded = JwtService.decode(token)
      
      expect(decoded[:user_id]).to eq(1)
    end
    
    it 'returns nil for invalid token' do
      decoded = JwtService.decode('invalid_token')
      
      expect(decoded).to be_nil
    end
    
    it 'returns nil for expired token' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload, 1.second.ago)
      
      sleep 1
      decoded = JwtService.decode(token)
      
      expect(decoded).to be_nil
    end
  end
end
```

---


