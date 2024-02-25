module AITools
  class RecipeImageInstructionsGenerator < ApplicationService
    def initialize(recipe, user_description: nil)
      @recipe = recipe
      @user_description = user_description
    end

    def call
      generate_image_instructions
    end

    private

    def generate_image_instructions
      base = @user_description.present? ? base_instructions_with_user_description : base_instructions
      (base + ingredients_instructions).truncate(1000)
    end

    def base_instructions
      <<~HEREDOC
        A photo of the end result from the following recipe.
        The title of the recipe is: #{@recipe.title}.
        The description of the recipe is: #{@recipe.description}.
        Show some of the raw ingredients from the list in the background of the image.
        Do not show anything thats not in the ingredient list.
        Do not show any text in the image. This is a photo taken on the kitchen counter.
      HEREDOC
    end

    def base_instructions_with_user_description
      <<~HEREDOC
        A photo of:
        #{@user_description}.
        Show some of the raw ingredients from the list in the background of the image.
        Do not show anything thats not in the ingredient list.
        Do not show any text in the image. This is a photo taken on the kitchen counter.
      HEREDOC
    end

    def ingredients_instructions
      <<~HEREDOC
        The ingredients are:
        #{@recipe.ingredients.map { |ingredient| "- #{ingredient.name}" }.join("\n")}
      HEREDOC
    end
  end
end
