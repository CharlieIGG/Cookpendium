# frozen_string_literal: true

module RecipeImporter
  # imports a recipe and its associated ingredients and recipe steps from a Hash
  class Importer < ApplicationService
    class ContentError < StandardError; end
    class DataStructureError < StandardError; end

    def initialize(recipe_data)
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
      valid_attributes = @recipe_data.select { |key, _| Recipe.attribute_names.include?(key) }
      @recipe = Recipe.create(valid_attributes)
    end

    def initialize_ingredients
      return if @recipe_data['ingredients'].nil?

      ModelIngredientAssigner.call(@recipe, @recipe_data['ingredients'])
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
      return if step_data['ingredients'].nil?

      ModelIngredientAssigner.call(step, step_data['ingredients'])
    end

    def save_recipe_changes
      @recipe.save!
    end
  end
end
