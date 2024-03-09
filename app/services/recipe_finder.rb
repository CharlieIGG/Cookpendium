# frozen_string_literal: true

# This is to search for recipes based on the search text and the ingredients selected by the user.
# since this service's only current purpose is to serve the "index" view, we're automatically
# filtering out recipes that aren't "complete"
# returns [ActiveRecord::Relation, Boolean] where the boolean indicates if a search (filter) is active
class RecipeFinder < ApplicationService
  attr_reader :search_ingredient_ids, :search_text
  attr_accessor :query

  def initialize(search_ingredient_ids, search_text)
    @search_ingredient_ids = search_ingredient_ids
    @search_text = search_text
    @query = Recipe
  end

  def call
    find_recipes
  end

  private

  def search_active?
    search_ingredient_ids.present? || search_text.present?
  end

  def find_recipes
    apply_search_clauses if search_active?
    [query.with_steps_and_ingredients.includes(:translations, :image_attachment), search_active?]
  end

  def apply_search_clauses
    self.query = query.joins(ingredients: [:translations])
    apply_text_search
    apply_ingredient_search
  end

  def apply_text_search
    return unless search_text.present?

    self.query = query.joins(:translations).where(
      'recipe_translations.title ILIKE :search OR recipe_translations.description ILIKE :search OR ingredient_translations.name ILIKE :search',
      search: "#{search_text}%"
    )
  end

  def apply_ingredient_search
    self.query = query.where(ingredients: { id: search_ingredient_ids }) if search_ingredient_ids.present?
  end
end
