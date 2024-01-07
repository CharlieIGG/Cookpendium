require 'rails_helper'

RSpec.describe 'ExploreRecipes', type: :system do # rubocop:disable Metrics/BlockLength
  describe 'viewing all recipes' do
    before do
      create_list(:recipe, 5)
    end
    it 'displays recipe titles and truncated descriptions on recipes_path' do
      # Add code to create some recipes here

      visit recipes_path

      # Assert that recipe titles are displayed
      Recipe.all.each do |recipe|
        expect(page).to have_content(recipe.title)

        # Assert that truncated recipe descriptions are displayed
        expect(page).to have_content(recipe.description.truncate(90))
      end
    end

    it 'navigates to recipe_path when clicking on a recipe' do
      # Add code to create a recipe here

      recipe = Recipe.first

      visit recipes_path

      # Click on the first recipe
      click_link recipe.title

      # Assert that the current path is the recipe_path of the clicked recipe
      expect(page).to have_current_path(recipe_path(recipe))
    end
  end

  describe 'viewing a specific recipe' do
    before do
      create(:recipe, :with_ingredients_and_measurements, :with_steps_and_step_ingredients_with_measurements)
    end
    it 'displays the recipe title, description, ingredients, and steps' do
      # Add code to create a recipe here

      recipe = Recipe.first

      visit recipe_path(recipe)

      # Assert that the recipe title and description are displayed
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.description)

      # Assert that the recipe ingredients are displayed
      recipe.recipe_steps.each do |step|
        step.recipe_step_ingredients.each do |rs_ingredient|
          expect(page).to have_content(rs_ingredient.ingredient.name)
          expect(page).to have_content(format('%g', ('%.2f' % rs_ingredient.quantity)))
          expect(page).to have_content(rs_ingredient.measurement_unit&.name)
        end

        # Assert that the recipe steps are displayed
        expect(page).to have_content(step.instruction)
        expect(page).to have_content(step.description)
      end
    end
  end
end
