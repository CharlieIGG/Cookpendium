# frozen_string_literal: true

# Core Recipe model
class Recipe < ApplicationRecord
  translates :title, :description

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_steps, dependent: :destroy
  has_many :recipe_step_ingredients, through: :recipe_steps, source: :ingredients

  validates :title, presence: true
  validates :description, presence: true
end
