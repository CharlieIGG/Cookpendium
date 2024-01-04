# frozen_string_literal: true

module RecipeImporter
  # does some superficial validation on the recipe hash before trying to import it
  class RecipeValidator
    def initialize(recipe)
      @recipe = recipe
    end

    def valid?
      return false unless @recipe.is_a?(Hash)
      return false unless @recipe['title'].is_a?(String) && @recipe['title'].length.positive?
      return false unless @recipe['description'].is_a?(String) && @recipe['description'].length.positive?
      return false unless validate_recipe_steps

      validate_ingredients
    end

    def validate_recipe_steps
      recipe_steps = @recipe['recipe_steps']
      return false unless recipe_steps.is_a?(Array) && recipe_steps.all? { |step| step.is_a?(Hash) }

      true
    end

    def validate_ingredients
      ingredients = @recipe['ingredients']

      return false unless ingredients.is_a?(Array) && ingredients.all? { |ingredient| ingredient.is_a?(Hash) }

      true
    end
  end
end
