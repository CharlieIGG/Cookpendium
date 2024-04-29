class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action -> { authorize @recipe }, only: %i[edit update destroy]

  def index
    @recipes, @search_active = RecipeFinder.call(**helpers.recipe_search_params.except(:page, :format))
    @pagy, @recipes = pagy(@recipes, items: 12)
    @recipes = @recipes.map { |recipe| RecipeDecorator.new(recipe) }
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @recipe.recipe_steps.build
    set_units_and_ingredients
  end

  def edit
    set_units_and_ingredients
  end

  def create
    raw_recipe = params.dig(:recipe, :ingredients_and_instructions)
    return create_with_ai(raw_recipe) if raw_recipe.present? && raw_recipe.length.positive?

    @recipe = Recipe.new(recipe_params)
    return after_save if @recipe.save

    handle_recipe_save_failure
  end

  def update
    return after_save if @recipe.update(recipe_params)

    handle_recipe_save_failure
  end

  def destroy
    @recipe.destroy!

    redirect_to recipes_path(status: :see_other, format: :html),
                notice: I18n.t('helpers.deleted.one', model: Recipe.model_name.human)
  end

  private

  def recipe_params
    params
      .require(:recipe)
      .permit(:title, :description, :image, :cooking_time_minutes, :prep_time_minutes, :serving_unit, :servings, :title,
              :vegan, :vegetarian, recipe_ingredients_attributes: %i[id ingredient_id quantity measurement_unit_id _destroy],
                                   recipe_steps_attributes: %i[id instruction description step_number _destroy])
  end

  def set_recipe
    @recipe = RecipeDecorator.new(Recipe.includes(
      :translations, recipe_ingredients: [measurement_unit: [:translations], ingredient: [:translations]],
                     recipe_steps: [:translations, { recipe_step_ingredients: [
                       ingredient: [:translations], measurement_unit: [:translations]
                     ] }]
    ).find(params[:id]))
  end

  def create_with_ai(raw_recipe)
    @recipe = AITools::RecipeCreator.call(raw_recipe, recipe_params[:title], recipe_params[:description])
    current_user.increment_ai_usage
    after_save
  rescue StandardError => e
    handle_recipe_import_error(e)
  end

  def after_save
    notice = I18n.t(action_name == 'create' ? 'helpers.created.one' : 'helpers.updated.one',
                    model: Recipe.model_name.human)
    current_user.add_role(:author, @recipe)
    redirect_to recipe_path(@recipe),
                notice:, status: :see_other
  end

  def handle_recipe_import_error(error)
    messages = {
      RecipeImporter::Importer::ContentError => I18n.t('helpers.errors.recipes.parser_content')
    }
    alert = messages[error.class] || I18n.t('helpers.errors.recipes.import')
    render turbo_stream: [
      turbo_stream.append('toasts_container', partial: 'shared/toast', locals: { message: alert, type: :alert })
    ]
  end

  def set_units_and_ingredients
    @available_ingredients = Ingredient.by_name
    @measurement_units = MeasurementUnit.by_name.map { |mu| MeasurementUnitDecorator.new(mu) }
  end

  def handle_recipe_save_failure
    set_units_and_ingredients

    render turbo_stream: recipe_create_turbo_stream
  end

  def recipe_create_turbo_stream
    model_name = Recipe.model_name.human
    error_message = I18n.t('helpers.errors.create', model: model_name)
    form_title = I18n.t('activerecord.actions.new', model: model_name)
    [
      turbo_stream.append('toasts_container', partial: 'shared/toast',
                                              locals: { message: error_message, type: :alert }),
      turbo_stream.update('new_recipe_form', partial: 'form',
                                             locals: { recipe: @recipe, available_ingredients: @available_ingredients,
                                                       measurement_units: @measurement_units, title: form_title })
    ]
  end
end
