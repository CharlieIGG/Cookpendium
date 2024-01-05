# frozen_string_literal: true

# == Schema Information
#
# Table name: recipe_ingredients
#
#  id                  :bigint           not null, primary key
#  quantity            :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ingredient_id       :bigint           not null
#  measurement_unit_id :bigint
#  recipe_id           :bigint           not null
#
# Indexes
#
#  index_recipe_ingredients_on_ingredient_id        (ingredient_id)
#  index_recipe_ingredients_on_measurement_unit_id  (measurement_unit_id)
#  index_recipe_ingredients_on_recipe_id            (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (measurement_unit_id => measurement_units.id)
#  fk_rails_...  (recipe_id => recipes.id)
#
class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :measurement_unit, optional: true

  validates :quantity, numericality: { greater_than: 0, allow_nil: true }
end
