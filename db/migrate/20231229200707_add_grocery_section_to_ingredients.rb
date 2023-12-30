class AddGrocerySectionToIngredients < ActiveRecord::Migration[7.0]
  def change
    add_reference :ingredients, :grocery_section, null: true, foreign_key: true
  end
end
