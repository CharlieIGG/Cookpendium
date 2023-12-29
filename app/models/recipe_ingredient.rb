# frozen_string_literal: true

# Declares the relationship between recipes and ingredients, including the unit of measurement and quantity
class RecipeIngredient < ApplicationRecord
  include Measurable

  belongs_to :recipe
  belongs_to :ingredient
end
