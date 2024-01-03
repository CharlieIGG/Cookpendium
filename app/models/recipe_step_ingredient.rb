# frozen_string_literal: true

# Declares the relationship between recipe steps and ingredients, including the unit of measurement and quantity
class RecipeStepIngredient < ApplicationRecord
  belongs_to :recipe_step
  belongs_to :ingredient
  belongs_to :measurement_unit

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
