class AddCategoryToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :category, :string
  end
end
