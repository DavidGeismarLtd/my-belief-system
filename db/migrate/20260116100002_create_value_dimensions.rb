class CreateValueDimensions < ActiveRecord::Migration[8.1]
  def change
    create_table :value_dimensions do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.text :description
      t.string :left_pole, null: false
      t.string :right_pole, null: false
      t.text :left_description
      t.text :right_description
      t.integer :position, null: false, default: 0
      t.boolean :active, default: true, null: false
      
      t.timestamps
    end
    
    add_index :value_dimensions, :key, unique: true
    add_index :value_dimensions, :position
    add_index :value_dimensions, :active
  end
end

