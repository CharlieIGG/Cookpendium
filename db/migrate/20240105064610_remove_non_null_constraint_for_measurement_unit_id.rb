class RemoveNonNullConstraintForMeasurementUnitId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :recipe_ingredients, :measurement_unit_id, true
    change_column_null :recipe_step_ingredients, :measurement_unit_id, true
  end
end
