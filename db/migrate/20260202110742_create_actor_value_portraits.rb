class CreateActorValuePortraits < ActiveRecord::Migration[8.1]
  def change
    create_table :actor_value_portraits do |t|
      t.references :actor, null: false, foreign_key: true
      t.references :value_dimension, null: false, foreign_key: true
      t.decimal :position, precision: 5, scale: 2, null: false
      t.decimal :intensity, precision: 5, scale: 2
      t.decimal :confidence, precision: 5, scale: 2

      t.timestamps
    end

    add_index :actor_value_portraits, [ :actor_id, :value_dimension_id ], unique: true, name: 'index_actor_portraits_on_actor_and_dimension'
    add_index :actor_value_portraits, :position
  end
end
