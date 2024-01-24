module Recipes
  class RecipeIngredientsController < ApplicationController
    def new
      @recipe = params[:recipe_id] ? Recipe.find(params[:recipe_id]) : Recipe.new
      @recipe_ingredient = @recipe.recipe_ingredients.build
      render turbo_stream: turbo_stream.append(:recipe_ingredients, partial: 'recipes/form/recipe_ingredient',
                                                                    locals: { recipe_ingredient: @recipe_ingredient })
    end

    def destroy
      @recipe_ingredient = RecipeIngredient.find(params[:id])
      @recipe_ingredient.destroy
      render turbo_stream: turbo_stream.remove(@recipe_ingredient)
    end

    def create
      @recipe = Recipe.find(params[:recipe_id])
      @recipe_ingredient = @recipe.recipe_ingredients.build(recipe_ingredient_params)
      if @recipe_ingredient.save
        render turbo_stream: turbo_stream.update(:recipe_ingredients, partial: 'recipes/form/recipe_ingredient',
                                                                      locals: { recipe_ingredient: @recipe_ingredient })
      else
        # Handle validation errors
      end
    end

    private

    def recipe_ingredient_params
      params.require(:recipe_ingredient).permit(:name, :quantity)
    end
  end
end
