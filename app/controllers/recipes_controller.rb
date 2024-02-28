class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action -> { authorize @recipe }, only: %i[edit update destroy]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.with_steps_and_ingredients.includes(:translations, :image_attachment).map do |recipe|
      RecipeDecorator.new(recipe)
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
  def edit; end

  # POST /recipes or /recipes.json
  def create
    raw_recipe = params.dig(:recipe, :ingredients_and_instructions)
    return create_with_ai(raw_recipe) if raw_recipe.present? && raw_recipe.length.positive?

    @recipe = Recipe.new(recipe_params)
    return after_create if @recipe.save

    handle_recipe_create_failure
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy!

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
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
    after_create
  rescue StandardError => e
    handle_recipe_import_error(e)
  end

  def after_create
    current_user.add_role(:author, @recipe)
    redirect_to recipe_path(@recipe),
                notice: I18n.t('helpers.created.one', model: Recipe.model_name.human), status: :see_other
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

  def handle_recipe_create_failure
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
