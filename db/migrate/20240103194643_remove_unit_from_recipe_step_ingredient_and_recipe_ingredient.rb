class RemoveUnitFromRecipeStepIngredientAndRecipeIngredient < ActiveRecord::Migration[7.0]
  def change
    remove_column :recipe_step_ingredients, :unit, :integer
    remove_column :recipe_ingredients, :unit, :integer
  end
end
