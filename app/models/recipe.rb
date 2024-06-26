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
  include AutoTranslateable
  resourcify

  translates :title, :description, :serving_unit

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_steps, dependent: :destroy
  has_many :recipe_step_ingredients, through: :recipe_steps, source: :ingredients
  has_many :roles, as: :resource, dependent: :destroy
  has_many :authors, -> { distinct }, through: :roles, class_name: 'User', source: :users

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [300, 300], preprocessed: true
  end

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :recipe_steps, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :description, presence: true

  scope :with_steps_and_ingredients, lambda {
    joins(:recipe_steps)
      .joins(:recipe_ingredients)
      .distinct
      .where.not(recipe_steps: { id: nil })
      .where.not(recipe_ingredients: { id: nil })
  }

  def draft?
    recipe_steps.count.zero? || recipe_ingredients.count.zero?
  end
end
