class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :value_dimension, null: false, foreign_key: true
      t.text :text, null: false
      t.string :question_type, null: false
      t.jsonb :options, default: {}
      t.integer :position, null: false, default: 0
      t.integer :difficulty_score, default: 1
      t.boolean :active, default: true, null: false
      
      t.timestamps
    end
    
    add_index :questions, :question_type
    add_index :questions, :position
    add_index :questions, :active
    add_index :questions, [:value_dimension_id, :position]
  end
end

