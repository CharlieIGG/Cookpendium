class CreateRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.float :quantity
      t.references :ingredient, null: false, foreign_key: true
      t.integer :unit

      t.timestamps
    end
    add_index :recipe_ingredients, :unit
  end
end
