class AddExtraAttributesToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :servings, :integer
    add_column :recipes, :vegetarian, :boolean
    add_column :recipes, :vegan, :boolean
    add_column :recipes, :cooking_time_minutes, :integer
    add_column :recipes, :prep_time_minutes, :integer
  end
end
