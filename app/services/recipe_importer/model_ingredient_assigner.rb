# frozen_string_literal: true

module RecipeImporter
  # assigns ingredients with measurement units to a Recipe or RecipeStep from a Hash
  class ModelIngredientAssigner < ApplicationService
    def initialize(object, ingredients_data) # rubocop:disable Lint/MissingSuper
      @object = object
      @ingredients_data = ingredients_data
    end

    def call
      @object.send("#{object_association_name}=", ingredients_with_measurements)
    end

    private

    def object_association_name
      case @object.class.name
      when 'Recipe'
        :recipe_ingredients
      when 'RecipeStep'
        :recipe_step_ingredients
      else
        raise ArgumentError, 'Invalid object'
      end
    end

    def object_association_class
      @object.class.reflect_on_association(object_association_name).class_name.constantize
    end

    def ingredients_with_measurements
      @ingredients_data.map do |ingredient_data|
        ingredient = Ingredient.find_or_create_by!(name: ingredient_data['ingredient_name'])
        measurement_unit = find_measurement_unit(ingredient_data)
        object_association_class.find_or_initialize_by(@object.class.name.underscore.to_sym => @object, ingredient:,
                                                       measurement_unit:, quantity: ingredient_data['quantity'])
      end
    end

    def find_measurement_unit(ingredient_data)
      return if ingredient_data['unit'].nil? || ingredient_data['unit'].empty?

      MeasurementUnit.find_or_create_by!(name: ingredient_data['unit'],
                                         abbreviation: ingredient_data['unit_short'])
    end
  end
end
