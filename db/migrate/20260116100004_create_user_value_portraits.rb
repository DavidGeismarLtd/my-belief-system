class CreateUserValuePortraits < ActiveRecord::Migration[8.1]
  def change
    create_table :user_value_portraits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :value_dimension, null: false, foreign_key: true
      t.decimal :position, precision: 5, scale: 2, null: false
      t.decimal :intensity, precision: 5, scale: 2
      t.decimal :confidence, precision: 5, scale: 2
      
      t.timestamps
    end
    
    add_index :user_value_portraits, [:user_id, :value_dimension_id], unique: true, name: 'index_user_portraits_on_user_and_dimension'
    add_index :user_value_portraits, :position
  end
end

