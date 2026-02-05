class AddCountryToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :country, :string
    add_column :questions, :is_universal, :boolean, default: false, null: false

    add_index :questions, :country
    add_index :questions, :is_universal
    add_index :questions, [ :country, :active, :position ], name: 'index_questions_on_country_active_position'
  end
end
