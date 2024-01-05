# == Schema Information
#
# Table name: recipe_step_ingredients
#
#  id                  :bigint           not null, primary key
#  quantity            :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ingredient_id       :bigint           not null
#  measurement_unit_id :bigint
#  recipe_step_id      :bigint           not null
#
# Indexes
#
#  index_recipe_step_ingredients_on_ingredient_id        (ingredient_id)
#  index_recipe_step_ingredients_on_measurement_unit_id  (measurement_unit_id)
#  index_recipe_step_ingredients_on_recipe_step_id       (recipe_step_id)
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (measurement_unit_id => measurement_units.id)
#  fk_rails_...  (recipe_step_id => recipe_steps.id)
#
require 'rails_helper'

RSpec.describe RecipeStepIngredient, type: :model do
  it { should validate_numericality_of(:quantity).is_greater_than(0).allow_nil }
  it { should belong_to(:measurement_unit).optional }
end
