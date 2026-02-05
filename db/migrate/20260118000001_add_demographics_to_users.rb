class AddDemographicsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :country, :string
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :political_engagement, :string

    add_index :users, :country
  end
end
