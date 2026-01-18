class CreateActors < ActiveRecord::Migration[8.1]
  def change
    create_table :actors do |t|
      t.string :name, null: false
      t.string :actor_type, null: false # 'party', 'personality', 'organization'
      t.string :country, null: false
      t.string :role
      t.string :party_affiliation
      t.text :description
      t.string :image_url
      t.string :program_url # For parties/organizations
      t.boolean :active, default: true, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :actors, :name
    add_index :actors, :actor_type
    add_index :actors, :country
    add_index :actors, :active
    add_index :actors, [:country, :actor_type, :active], name: 'index_actors_on_country_type_active'
  end
end

