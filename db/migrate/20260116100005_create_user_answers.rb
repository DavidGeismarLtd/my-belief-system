class CreateUserAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.jsonb :answer_data, null: false, default: {}

      t.timestamps
    end

    add_index :user_answers, [ :user_id, :question_id ], unique: true
    add_index :user_answers, :created_at
    add_index :user_answers, :answer_data, using: :gin
  end
end
