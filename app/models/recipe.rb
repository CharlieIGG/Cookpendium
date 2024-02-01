# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id                   :bigint           not null, primary key
#  cooking_time_minutes :integer
#  description          :text             not null
#  prep_time_minutes    :integer
#  serving_unit         :string
#  servings             :integer
#  title                :string           not null
#  vegan                :boolean
#  vegetarian           :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Recipe < ApplicationRecord
  resourcify

  translates :title, :description, :serving_unit

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_steps, dependent: :destroy
  has_many :recipe_step_ingredients, through: :recipe_steps, source: :ingredients
  has_many :authors, -> { distinct }, through: :roles, class_name: 'User', source: :users
  has_many :roles, as: :resource, dependent: :destroy

  has_one_attached :image

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :recipe_steps, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :description, presence: true

  scope :with_steps_and_ingredients, lambda {
                                       joins(:recipe_steps, :recipe_ingredients)
                                         .group('recipes.id')
                                         .having('COUNT(DISTINCT recipe_steps.id) > 0 AND COUNT(DISTINCT recipe_ingredients.id) > 0')
                                     }
end
