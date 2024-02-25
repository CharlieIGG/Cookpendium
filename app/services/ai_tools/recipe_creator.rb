module AITools
  class RecipeCreator < ApplicationService
    class RecipeImportError < StandardError; end

    def initialize(raw_recipe, title, description)
      @raw_recipe = raw_recipe
      @title = title
      @description = description
    end

    def call
      @recipe_hash = AITools::RecipeParser.call(@raw_recipe)
      update_recipe_attributes
      import_recipe
    end

    private

    def update_recipe_attributes
      update_recipe_title
      update_recipe_description
    end

    def update_recipe_title
      @recipe_hash['title'] = @title if @title.present? && @title.length.positive?
    end

    def update_recipe_description
      @recipe_hash['description'] = @description if @description.present? && @description.length.positive?
    end

    def import_recipe
      @recipe = RecipeImporter::Importer.call(@recipe_hash)
    end
  end
end
