# frozen_string_literal: true

# Declares the relationship between recipe steps and ingredients, including the unit of measurement and quantity
class RecipeStepIngredient < ApplicationRecord
  include Measurable

  belongs_to :recipe_step
  belongs_to :ingredient
end
