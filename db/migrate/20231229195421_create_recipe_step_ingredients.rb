class CreateRecipeStepIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_step_ingredients do |t|
      t.references :recipe_step, null: false, foreign_key: true
      t.float :quantity
      t.references :ingredient, null: false, foreign_key: true
      t.integer :unit

      t.timestamps
    end
    add_index :recipe_step_ingredients, :unit
  end
end
