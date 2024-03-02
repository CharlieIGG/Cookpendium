require 'rails_helper'

RSpec.describe 'ExploreRecipes', type: :system do
  describe 'viewing all recipes' do
    let_it_be(:recipes) { create_list(:recipe, 5, :with_ingredients, :with_steps) }

    it 'displays recipe titles and truncated descriptions on recipes_path' do
      visit recipes_path

      recipes.each do |recipe|
        expect(page).to have_content(recipe.title)

        expect(page).to have_content(recipe.description.truncate(90))
      end
    end

    it 'navigates to recipe_path when clicking on a recipe' do
      # Add code to create a recipe here

      recipe = recipes.first

      visit recipes_path

      # Click on the first recipe
      click_link recipe.title

      # Assert that the current path is the recipe_path of the clicked recipe
      expect(page).to have_current_path(recipe_path(recipe))
    end

    it 'only shows recipes that have both ingredients and steps' do
      recipe_without_ingredients_or_steps = create(:recipe)
      recipe_without_ingredients = create(:recipe, :with_steps)
      recipe_without_steps = create(:recipe, :with_ingredients)

      visit recipes_path

      [recipe_without_ingredients_or_steps, recipe_without_ingredients, recipe_without_steps].each do |recipe|
        expect(page).not_to have_content(recipe.title)
      end
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
          expect(page).to have_content(rs_ingredient.measurement_unit.name) if rs_ingredient.measurement_unit&.name
        end

        # Assert that the recipe steps are displayed
        expect(page).to have_content(step.instruction)
        expect(page).to have_content(step.description)
      end
    end

    describe 'when the user is not logged in' do
      it 'does not display the edit and delete buttons' do
        recipe = Recipe.first

        visit recipe_path(recipe)

        expect(page).not_to have_content(I18n.t('activerecord.actions.edit', model: Recipe.model_name.human))
        expect(page).not_to have_content(I18n.t('activerecord.actions.delete', model: Recipe.model_name.human))
      end
    end
    describe 'when the user is logged in' do
      let_it_be(:user) { create(:user) }

      describe 'when the user is not the Author in' do
        it 'does not display the edit and delete buttons' do
          recipe = Recipe.first

          login_as user
          visit recipe_path(recipe)

          expect(page).not_to have_content(I18n.t('activerecord.actions.edit', model: Recipe.model_name.human))
          expect(page).not_to have_content(I18n.t('activerecord.actions.delete', model: Recipe.model_name.human))
        end
      end

      describe 'when the user is the Author' do
        let(:recipe) { Recipe.first }

        before(:each) do
          user.add_role(:author, recipe)
          login_as user
          visit recipe_path(recipe)
        end

        it 'displays the edit and delete buttons' do
          expect(page).to have_content(I18n.t('activerecord.actions.edit', model: Recipe.model_name.human))
          expect(page).to have_content(I18n.t('activerecord.actions.delete', model: Recipe.model_name.human))
        end

        it 'can go to edit the recipe' do
          click_link I18n.t('activerecord.actions.edit', model: Recipe.model_name.human)

          expect(page).to have_current_path(edit_recipe_path(recipe))
        end

        describe 'deleting a recipe' do
          it 'displays the delete button' do
            expect(page).to have_content(I18n.t('activerecord.actions.delete', model: Recipe.model_name.human))
          end

          it 'deletes the recipe when confirmation is accepted' do
            accept_confirm do
              click_link I18n.t('activerecord.actions.delete', model: Recipe.model_name.human)
            end

            expect(page).to have_content(I18n.t('helpers.deleted.one', model: Recipe.model_name.human))
            expect(Recipe.exists?(recipe.id)).to be_falsey
          end

          it 'does not delete the recipe when confirmation is dismissed' do
            dismiss_confirm do
              click_link I18n.t('activerecord.actions.delete', model: Recipe.model_name.human)
            end

            expect(page).not_to have_content(I18n.t('recipes.destroy.success', title: recipe.title))
            expect(Recipe.exists?(recipe.id)).to be_truthy
          end
        end
      end
    end
  end
end
