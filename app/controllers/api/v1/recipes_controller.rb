class Api::V1::RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :destroy]

  def index
    recipe = Recipe.all.order(created_at: :desc)
    render json: recipe
  end

  def create
    recipe = Recipe.create!(recipe_params)
    if recipe
      render json: recipe
    else
      render json: recipe.errors
    end
  end

  def show
    render json: @recipe
  end

  def destroy
    if @recipe.destroy!
      render json: @recipe
    else
      render json: @recipe.errors
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.permit(:name, :image, :ingredients, :instruction)
  end
end
