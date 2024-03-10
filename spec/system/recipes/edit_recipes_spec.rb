require 'rails_helper'

RSpec.describe 'Edit Recipes', type: :system do
  let_it_be(:recipe) do
    create(:recipe, :with_steps_and_step_ingredients_with_measurements, :with_ingredients_and_measurements)
  end

  let_it_be(:user) { create(:user) }

  describe 'requires authentication' do
    it 'redirects to login page' do
      visit edit_recipe_path(recipe)
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  describe 'authenticated user' do
    before do
      login_as user
    end

    describe 'for non-author standard users' do
      it 'redirects to root path' do
        visit edit_recipe_path(recipe)
        expect(page).to have_content(I18n.t('pundit.unauthorized.default'))
      end
    end

    describe 'for admins' do
      it 'allows editing' do
        user.add_role(:admin)
        visit edit_recipe_path(recipe)
        expect(page).to have_content(I18n.t('activerecord.actions.edit', model: Recipe.model_name.human))
      end
    end

    describe 'for the author' do
      before do
        user.add_role(:author, recipe)
      end

      it 'allows editing' do
        visit edit_recipe_path(recipe)
        expect(page).to have_content(I18n.t('activerecord.actions.edit', model: Recipe.model_name.human))
      end

      it 'can update the recipe\'s title and description' do
        visit edit_recipe_path(recipe)
        within('.recipe__main') do
          fill_in 'Title', with: 'Updated Title'
          fill_in 'Description', with: 'Updated Description'
        end
        click_button 'Update Recipe'
        expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        expect(page).to have_content('Updated Title')
        expect(page).to have_content('Updated Description')
      end

      it 'can update an ingredient' do
        visit edit_recipe_path(recipe)
        within('.recipe__ingredients_panel') do
          within('.nested-recipe-ingredient-wrapper:nth-of-type(1)') do
            fill_in RecipeIngredient.human_attribute_name(:quantity), with: 10
          end
        end
        click_button 'Update Recipe'
        expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        expect(page).to have_content('10')
      end

      it 'can remove an ingredient' do
        visit edit_recipe_path(recipe)
        within(".nested-recipe-ingredient-wrapper:nth-of-type(#{recipe.recipe_ingredients.count})") do
          find("a[title='Delete']").click
        end
        expect do
          click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        end.to change(RecipeIngredient, :count).by(-1)
      end

      it 'can add a new ingredient' do
        visit edit_recipe_path(recipe)
        new_ingredient_count = recipe.recipe_ingredients.count + 1
        expect do
          within('.recipe__ingredients_panel') do
            find("button[title='#{I18n.t('forms.add_new')}']").click

            expect(all('label',
                       text: RecipeIngredient.human_attribute_name(:quantity)).count).to eq(new_ingredient_count)

            new_ingredient_name = 'New Ingredient'
            new_measurement_unit_name = 'New Measurement Unit'
            page.execute_script("document.querySelector('.recipe__ingredients_panel').scrollTo(0, document.querySelector('.recipe__ingredients_panel').scrollHeight)")
            within(".nested-recipe-ingredient-wrapper:nth-of-type(#{new_ingredient_count})") do
              fill_in RecipeIngredient.human_attribute_name(:quantity), with: 10
              smart_select(new_ingredient_name,
                           from: RecipeIngredient.human_attribute_name(:ingredient),
                           wrapper_css_selector: '.col', create: true)

              smart_select(new_measurement_unit_name,
                           from: RecipeIngredient.human_attribute_name(:measurement_unit_short),
                           wrapper_css_selector: '.col', create: true)
            end
          end

          expect do
            click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)
            expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
          end.to change(RecipeIngredient, :count).by(1)
        end.to change(Ingredient, :count).by(1).and change(MeasurementUnit, :count).by(1)
      end

      it 'can update a step' do
        visit edit_recipe_path(recipe)
        within('.recipe__steps_panel') do
          within('.nested-recipe-step-wrapper:nth-of-type(1)') do
            fill_in RecipeStep.human_attribute_name(:instruction), with: 'My Updated Instruction'
            fill_in RecipeStep.human_attribute_name(:description), with: 'My Updated Longer Description'
          end
        end
        click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)
        expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        expect(page).to have_content('My Updated Instruction')
        expect(page).to have_content('My Updated Longer Description')
      end

      it 'can remove a step' do
        visit edit_recipe_path(recipe)
        within(".nested-recipe-step-wrapper:nth-of-type(#{recipe.recipe_steps.count})") do
          find("a[title='Delete']").click
        end
        expect do
          click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        end.to change(RecipeStep, :count).by(-1)
      end

      it 'can add a new step' do
        visit edit_recipe_path(recipe)
        new_step_count = recipe.recipe_steps.count + 1
        within('.recipe__steps_panel') do
          find("button[title='#{I18n.t('forms.add_new')}']").click

          expect(all('label', text: RecipeStep.human_attribute_name(:step_number)).count).to eq(new_step_count)

          within(".nested-recipe-step-wrapper:nth-of-type(#{new_step_count})") do
            fill_in RecipeStep.human_attribute_name(:instruction), with: 'My Instruction 2'
            fill_in RecipeStep.human_attribute_name(:description), with: 'My Longer Description 2'
            fill_in RecipeStep.human_attribute_name(:step_number), with: new_step_count
          end
        end
        page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
        expect do
          click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        end.to change(RecipeStep, :count).by(1)
      end

      it 'can update additional attributes' do
        cooking_time_minutes  = 20
        prep_time_minutes     = 15
        serving_unit          = 'People'
        servings              = 4
        visit edit_recipe_path(recipe)

        fill_in Recipe.human_attribute_name('prep_time_minutes_long'), with: prep_time_minutes
        fill_in Recipe.human_attribute_name('cooking_time_minutes_long'), with: cooking_time_minutes
        fill_in Recipe.human_attribute_name('serving_unit'), with: serving_unit
        fill_in Recipe.human_attribute_name('servings'), with: servings
        check Recipe.human_attribute_name('vegan')
        check Recipe.human_attribute_name('vegetarian')
        click_button I18n.t('helpers.submit.update', model: Recipe.model_name.human)

        expect(page).to have_content(I18n.t('helpers.updated.one', model: Recipe.model_name.human))
        expect(page).to have_content("#{cooking_time_minutes} #{I18n.t('time.mins')} #{Recipe.human_attribute_name('cooking_time_minutes')}")
        expect(page).to have_content("#{prep_time_minutes} #{I18n.t('time.mins')} #{Recipe.human_attribute_name('prep_time_minutes')}")
        expect(page).to have_content("#{servings} #{serving_unit}")
        expect(page).to have_content(Recipe.human_attribute_name('vegan'))
        expect(recipe.reload.vegetarian).to be_truthy # if a recipe is marked with bothvegan and vegetarian, we just show "vegan"
      end
    end
  end
end
