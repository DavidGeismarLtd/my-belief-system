class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # Devise fields
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      
      # Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      
      # Rememberable
      t.datetime :remember_created_at
      
      # Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      
      # Custom fields
      t.string :name
      t.boolean :onboarding_completed, default: false, null: false
      t.integer :onboarding_progress, default: 0, null: false
      t.jsonb :skipped_questions, default: []
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :onboarding_completed
  end
end

