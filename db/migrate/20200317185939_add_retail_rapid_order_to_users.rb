class AddRetailRapidOrderToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :retail_rapid_order, :boolean
  end
end
