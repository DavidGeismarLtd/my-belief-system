class CreateInterventions < ActiveRecord::Migration[8.1]
  def change
    create_table :interventions do |t|
      t.references :actor, null: false, foreign_key: true
      t.string :intervention_type, null: false # 'tweet', 'video', 'declaration', 'speech', 'article'
      t.text :content
      t.string :source_url
      t.string :source_platform # 'twitter', 'youtube', 'press_release', etc.
      t.datetime :published_at
      t.jsonb :metadata, default: {}
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :interventions, :intervention_type
    add_index :interventions, :published_at
    add_index :interventions, :active
    add_index :interventions, [ :actor_id, :published_at ], name: 'index_interventions_on_actor_and_published'
  end
end
