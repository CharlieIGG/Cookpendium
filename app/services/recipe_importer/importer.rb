# frozen_string_literal: true

module RecipeImporter
  # imports a recipe and its associated ingredients and recipe steps from a Hash
  class Importer
    def initialize(json_data)
      @recipe_data = JSON.parse(json_data)
      validate_recipe_data
    end

    def import
      create_recipe
      create_or_update_ingredients
      create_recipe_steps
      save_recipe_changes
    end

    private

    def validate_recipe_data
      validator = RecipeValidator.new(@recipe_data)
      return if validator.valid?

      raise StandardError, "Invalid recipe data: #{validator.errors.full_messages.join(', ')}"
    end

    #   probably doesn't make sense to "find" a recipe by name... TBD
    def create_recipe
      @recipe = Recipe.create(@recipe_data.except('ingredients', 'recipeSteps'))
    end

    def create_or_update_ingredients
      @recipe.recipe_ingredients = @recipe_data['ingredients'].map do |ingredient_data|
        ingredient = Ingredient.find_or_initialize_by(name: ingredient_data['name'])
        measurement_unit = MeasurementUnit.find_or_initialize_by(name: ingredient_data['unit'])
        RecipeIngredient.find_or_initialize_by(recipe: @recipe, ingredient:, measurement_unit:,
                                               quantity: ingredient_data['quantity'])
      end
    end

    # requires adjustments
    def create_or_update_recipe_steps
      @recipe.recipe_steps = @recipe_data['recipeSteps'].map do |step_data|
        step = RecipeStep.find_or_initialize_by(description: step_data['description'])
        step.attributes = step_data
        step
      end
    end

    def save_recipe_changes
      @recipe.save
    end
  end
end
