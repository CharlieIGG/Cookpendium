# frozen_string_literal: true

module RecipeImporter
  # imports a recipe and its associated ingredients and recipe steps from a Hash
  class Importer < ApplicationService
    class ContentError < StandardError; end
    class DataStructureError < StandardError; end

    def initialize(recipe_data) # rubocop:disable Lint/MissingSuper
      @recipe_data = recipe_data
    end

    def call
      validate_recipe_data
      create_recipe
      initialize_ingredients
      initialize_recipe_steps
      save_recipe_changes
      @recipe
    end

    private

    def validate_recipe_data
      raise ContentError, I18n.t('helpers.errors.recipes.parser_content') if @recipe_data['error']
      return if RecipeValidator.call(@recipe_data)

      raise DataStructureError, 'Invalid recipe data: structure does not match expected format or data is missing'
    end

    def create_recipe
      @recipe = Recipe.create(@recipe_data.except('ingredients', 'recipe_steps'))
    end

    def initialize_ingredients
      ingredients = @recipe_data['ingredients'].map do |ingredient_data|
        ingredient = Ingredient.find_or_create_by!(name: ingredient_data['ingredient'])
        unless ingredient_data['unit'].nil? || ingredient_data['unit'].empty?
          measurement_unit = MeasurementUnit.find_or_create_by!(name: ingredient_data['unit'],
                                                                abbreviation: ingredient_data['unit_short'])
        end
        RecipeIngredient.find_or_initialize_by(recipe: @recipe, ingredient:, measurement_unit:,
                                               quantity: ingredient_data['quantity'])
      end
      # debugger
      @recipe.recipe_ingredients = ingredients
    end

    def initialize_recipe_steps
      @recipe.recipe_steps = @recipe_data['recipe_steps'].map do |step_data|
        step = RecipeStep.new(description: step_data['description'], instruction: step_data['instruction'],
                              step_number: step_data['step_number'])
        assign_ingredients_to_recipe_step(step_data, step)
        step
      end
    end

    def assign_ingredients_to_recipe_step(step_data, step)
      step.recipe_step_ingredients = step_data['ingredients'].map do |ingredient_data|
        ingredient = Ingredient.find_or_create_by!(name: ingredient_data['ingredient'])
        unless ingredient_data['unit'].nil? || ingredient_data['unit'].empty?
          measurement_unit = MeasurementUnit.find_or_create_by!(name: ingredient_data['unit'],
                                                                abbreviation: ingredient_data['unit_short'])
        end
        RecipeStepIngredient.find_or_initialize_by(recipe_step: step, ingredient:, measurement_unit:,
                                                   quantity: ingredient_data['quantity'])
      end
    end

    def save_recipe_changes
      @recipe.save!
    end
  end
end
