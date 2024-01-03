class AddMeasurementUnitToRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipe_ingredients, :measurement_unit, null: false, foreign_key: true
  end
end
