class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action -> { authorize @recipe }, only: %i[edit update destroy]

  # GET /recipes or /recipes.json
  def index
    @search_active = params[:search_ingredient_ids].present? || params[:search_text].present?
    @pagy, @recipes = pagy(search_recipes, items: 12)
    @recipes = @recipes.map { |recipe| RecipeDecorator.new(recipe) }
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /recipes/1 or /recipes/1.json
  def show; end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @recipe.recipe_steps.build
    set_units_and_ingredients
  end

  # GET /recipes/1/edit
  def edit
    set_units_and_ingredients
  end

  # POST /recipes or /recipes.json
  def create
    raw_recipe = params.dig(:recipe, :ingredients_and_instructions)
    return create_with_ai(raw_recipe) if raw_recipe.present? && raw_recipe.length.positive?

    @recipe = Recipe.new(recipe_params)
    return after_save if @recipe.save

    handle_recipe_save_failure
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    return after_save if @recipe.update(recipe_params)

    handle_recipe_save_failure
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy!

    redirect_to recipes_path(status: :see_other, format: :html),
                notice: I18n.t('helpers.deleted.one', model: Recipe.model_name.human)
  end

  private

  # Only allow a list of trusted parameters through.
  def recipe_params
    params
      .require(:recipe)
      .permit(:title, :description, :image,
              recipe_ingredients_attributes: %i[id ingredient_id quantity measurement_unit_id _destroy],
              recipe_steps_attributes: %i[id instruction description step_number _destroy])
  end

  # Use callbacks to share common setup or constraints between actions.
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

def search_recipes
  query = Recipe
  query = query.joins(ingredients: [:translations]) if @search_active
  query = apply_text_search(query)
  query = apply_ingredient_search(query)
  query.with_steps_and_ingredients.includes(:translations, :image_attachment)
end

def apply_text_search(query)
  if params[:search_text].present?
    query = query.joins(:translations).where(
      'recipe_translations.title ILIKE :search OR recipe_translations.description ILIKE :search OR ingredient_translations.name ILIKE :search',
      search: "#{params[:search_text]}%"
    )
  end

  query
end

def apply_ingredient_search(query)
  query = query.where(ingredients: { id: params[:search_ingredient_ids] }) if params[:search_ingredient_ids].present?

  query
end
