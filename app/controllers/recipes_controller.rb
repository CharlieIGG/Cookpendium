class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_recipe, only: %i[show edit update destroy]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.with_steps_and_ingredients.map { |recipe| RecipeDecorator.new(recipe) }
  end

  # GET /recipes/1 or /recipes/1.json
  def show; end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  # POST /recipes or /recipes.json
  def create
    raw_recipe = params.dig(:recipe, :ingredients_and_instructions)
    return create_recipe_from_raw_text(raw_recipe) if raw_recipe.present? && raw_recipe.length.positive?

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

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = RecipeDecorator.new(Recipe.find(params[:id]))
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:title, :description)
  end

  def create_recipe_from_raw_text(raw_recipe)
    recipe_hash = AITools::RecipeParser.call(raw_recipe)
    update_recipe_attributes(recipe_hash)
    import_recipe(recipe_hash)
  rescue StandardError => e
    handle_recipe_import_error(e)
  end

  def update_recipe_attributes(recipe_hash)
    update_recipe_title(recipe_hash)
    update_recipe_description(recipe_hash)
  end

  def update_recipe_title(recipe_hash)
    title = recipe_params[:title]
    recipe_hash['title'] = title if title.present? && title.length.positive?
  end

  def update_recipe_description(recipe_hash)
    description = recipe_params[:description]
    recipe_hash['description'] = description if description.present? && description.length.positive?
  end

  def import_recipe(recipe_hash)
    @recipe = RecipeImporter::Importer.call(recipe_hash)
    after_create
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

  def handle_recipe_create_failure
    render turbo_stream: [
      turbo_stream.append('toasts_container', partial: 'shared/toast',
                                              locals: { message: I18n.t('helpers.errors.create', model: Recipe.model_name.human), type: :alert }),
      turbo_stream.update('new_recipe_form', partial: 'form', locals: { recipe: @recipe })
    ]
  end
end
