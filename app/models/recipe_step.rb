# frozen_string_literal: true

# == Schema Information
#
# Table name: recipe_steps
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  instruction :text
#  step_number :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
# Purpose: Model for recipe steps. A recipe step is a step in a recipe, such as "mix the flour and eggs together".
class RecipeStep < ApplicationRecord
  include AutoTranslateable

  belongs_to :recipe
  has_many :recipe_step_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_step_ingredients

  translates :instruction, :description

  validates :instruction, presence: true
  validates :step_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
