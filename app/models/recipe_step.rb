# frozen_string_literal: true

# Purpose: Model for recipe steps. A recipe step is a step in a recipe, such as "mix the flour and eggs together".
class RecipeStep < ApplicationRecord
  belongs_to :recipe
  has_many :recipe_step_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_step_ingredients

  translates :instruction

  validates :instruction, presence: true
end
