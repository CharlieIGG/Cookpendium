# frozen_string_literal: true

module RecipeImporter
  # imports a recipe and its associated ingredients and recipe steps from a Hash
  class Importer
    def initialize(recipe_data)
      @recipe_data = recipe_data
      validate_recipe_data
    end

    def import
      create_recipe
      initialize_ingredients
      initialize_recipe_steps
      save_recipe_changes
    end

    private

    def validate_recipe_data
      validator = RecipeValidator.new(@recipe_data)
      return if validator.valid?

      raise StandardError, "Invalid recipe data: #{validator.errors.full_messages.join(', ')}"
    end

    def create_recipe
      @recipe = Recipe.create(@recipe_data.except('ingredients', 'recipeSteps'))
    end

    def initialize_ingredients
      @recipe.recipe_ingredients = @recipe_data['ingredients'].map do |ingredient_data|
        ingredient = Ingredient.find_or_initialize_by(name: ingredient_data['name'])
        measurement_unit = MeasurementUnit.find_or_initialize_by(name: ingredient_data['unit'])
        RecipeIngredient.find_or_initialize_by(recipe: @recipe, ingredient:, measurement_unit:,
                                               quantity: ingredient_data['quantity'])
      end
    end

    def initialize_recipe_steps
      @recipe.recipe_steps = @recipe_data['recipeSteps'].map do |step_data|
        step = RecipeStep.new(description: step_data['description'], instruction: step_data['instruction'],
                              step_number: step_data['stepNumber'])
        assign_ingredients_to_recipe_step(step_data, step)
        step
      end
    end

    def assign_ingredients_to_recipe_step(step_data, step)
      step.recipe_step_ingredients = step_data['ingredients'].map do |ingredient_data|
        ingredient = Ingredient.find_or_initialize_by(name: ingredient_data['name'])
        measurement_unit = MeasurementUnit.find_or_initialize_by(name: ingredient_data['unit'])
        RecipeStepIngredient.find_or_initialize_by(recipe_step: step, ingredient:, measurement_unit:,
                                                   quantity: ingredient_data['quantity'])
      end
    end

    def save_recipe_changes
      @recipe.save!
    end
  end
end
