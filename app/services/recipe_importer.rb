class RecipeImporter
  def initialize(json_data)
    @recipe_data = JSON.parse(json_data)
    # should probably validate the data here
  end

  def import
    find_or_initialize_recipe
    assign_recipe_attributes
    create_or_update_ingredients
    create_or_update_recipe_steps
    save_recipe_changes
  end

  private

  #   probably doesn't make sense to "find" a recipe by name... TBD
  def find_or_initialize_recipe
    @recipe = Recipe.find_or_initialize_by(name: @recipe_data['name'])
  end

  # requires adjustments
  def assign_recipe_attributes
    @recipe.attributes = @recipe_data.except('ingredients', 'recipeSteps')
  end

  def create_or_update_ingredients
    @recipe.ingredients = @recipe_data['ingredients'].map do |ingredient_data|
      ingredient = Ingredient.find_or_initialize_by(name: ingredient_data['name'])
      # perhaps should do "next" if the ingredient already exists?
      ingredient.attributes = ingredient_data
      ingredient
    end
  end

  # requires adjustments
  def create_or_update_recipe_steps
    @recipe.recipe_steps = @recipe_data['recipeSteps'].map do |step_data|
      step = RecipeStep.find_or_initialize_by(description: step_data['description'])
      step.attributes = step_data
      step
    end
  end

  def save_recipe_changes
    @recipe.save
  end
end
