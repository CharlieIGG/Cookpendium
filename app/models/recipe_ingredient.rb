# frozen_string_literal: true

# Declares the relationship between recipes and ingredients, including the unit of measurement and quantity
class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :measurement_unit

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
