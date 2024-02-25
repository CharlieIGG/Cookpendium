require 'rails_helper'

RSpec.describe 'Create Recipes', type: :system do
  describe 'creating recipes requires authentication' do
    it 'redirects to login page' do
      visit new_recipe_path
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  describe 'creating new recipe via Form Fields' do
    let_it_be(:user) { create(:user) }

    before(:each) do
      login_as user
    end

    describe 'using a raw text recipe (AI Tools)' do
      it 'can create a new recipe out of a raw text recipe' do
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt')).gsub(
          "\n", "\r\n"
        )
        recipe_hash = YAML.load_file(Rails.root.join('spec', 'fixtures', 'recipe_hash.yaml'))
        allow(AITools::RecipeParser).to receive(:call).with(ingredients_and_instructions).and_return(recipe_hash)

        visit new_recipe_path

        fill_in Recipe.human_attribute_name(:ingredients_and_instructions), with: ingredients_and_instructions

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.loading.base'))
          expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
          expect(AITools::RecipeParser).to have_received(:call).with(ingredients_and_instructions)
        end.to change(Recipe, :count).by(1)
        expect(Recipe.last.title).to eq(recipe_hash['title'])
      end

      it 'User\'s title and description override that of the raw text recipe' do
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt')).gsub(
          "\n", "\r\n"
        )
        recipe_hash = YAML.load_file(Rails.root.join('spec', 'fixtures', 'recipe_hash.yaml'))
        allow(AITools::RecipeParser).to receive(:call).with(ingredients_and_instructions).and_return(recipe_hash)

        visit new_recipe_path

        users_title = 'My Title'
        users_description = 'My Description'

        fill_in Recipe.human_attribute_name(:title), with: users_title
        fill_in Recipe.human_attribute_name(:description), with: users_description
        fill_in Recipe.human_attribute_name(:ingredients_and_instructions), with: ingredients_and_instructions

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
        end.to change(Recipe, :count).by(1)
        expect(Recipe.last.title).to eq(users_title)
        expect(Recipe.last.description).to eq(users_description)
      end

      it 'properly handles content errors' do
        allow(AITools::RecipeParser).to receive(:call).and_return({ 'error' => 'Some Content Error' })

        visit new_recipe_path

        fill_in Recipe.human_attribute_name(:title), with: 'Users title'
        fill_in Recipe.human_attribute_name(:description), with: 'Users description'
        fill_in Recipe.human_attribute_name(:ingredients_and_instructions), with: 'Ingredients and instructions'

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.errors.recipes.parser_content'))
        end.to change(Recipe, :count).by(0)
      end

      it 'properly attributes authorship' do
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt')).gsub(
          "\n", "\r\n"
        )
        recipe_hash = YAML.load_file(Rails.root.join('spec', 'fixtures', 'recipe_hash.yaml'))
        allow(AITools::RecipeParser).to receive(:call).with(ingredients_and_instructions).and_return(recipe_hash)

        visit new_recipe_path

        fill_in Recipe.human_attribute_name(:ingredients_and_instructions), with: ingredients_and_instructions

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
        end.to change(Recipe, :count).by(1)
        expect(Recipe.last.authors.last).to eq(user)
      end
    end

    describe 'without AI Tools' do
      let_it_be(:user) { create(:user) }

      before(:each) do
        login_as user
      end

      it 'can create a recipe with just a title and description' do
        visit new_recipe_path

        users_title = 'My Title'
        users_description = 'My Description'

        fill_in Recipe.human_attribute_name(:title), with: users_title
        fill_in Recipe.human_attribute_name(:description), with: users_description

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
        end.to change(Recipe, :count).by(1)
        expect(Recipe.last.title).to eq(users_title)
        expect(Recipe.last.description).to eq(users_description)
      end

      it 'can manually assign ingredients, and create ingredients and measurement units on-the-fly' do
        existing_ingredient = create(:ingredient)
        existing_measurement_unit = create(:measurement_unit)

        visit new_recipe_path

        users_title = 'My Title'
        users_description = 'My Description'

        expect(page).to have_content(Ingredient.model_name.human.pluralize)

        fill_in Recipe.human_attribute_name(:title), with: users_title
        fill_in Recipe.human_attribute_name(:description), with: users_description

        find('label', text: I18n.t('helpers.ai_tools.use_ai')).click

        fill_in(RecipeIngredient.human_attribute_name(:ingredient), with: existing_ingredient.name,
                                                                    visible: false).send_keys(:return)
        fill_in RecipeIngredient.human_attribute_name(:quantity), with: 20
        fill_in(RecipeIngredient.human_attribute_name(:measurement_unit_short), with: existing_measurement_unit.name,
                                                                                visible: false).send_keys(:return)
        new_ingredient_name = 'NEW Ingredient'
        new_measurement_unit_name = 'NEW MSMT UNIT'

        expect do
          within('.recipe__ingredients_panel') do
            find("button[title='#{I18n.t('forms.add_new')}']").click
          end

          expect(all('label', text: RecipeIngredient.human_attribute_name(:quantity)).count).to eq(2)

          within('.nested-recipe-ingredient-wrapper:nth-of-type(2)') do
            fill_in RecipeIngredient.human_attribute_name(:quantity), with: 10
            smart_select(new_ingredient_name,
                         from: RecipeIngredient.human_attribute_name(:ingredient),
                         wrapper_css_selector: '.col', create: true)

            smart_select(new_measurement_unit_name,
                         from: RecipeIngredient.human_attribute_name(:measurement_unit_short),
                         wrapper_css_selector: '.col', create: true)
          end

          expect do
            click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
            expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
          end.to change(RecipeIngredient, :count).by(2)
        end.to change(Ingredient, :count).by(1).and change(MeasurementUnit, :count).by(1)

        expect(RecipeIngredient.last.name).to eq(new_ingredient_name)
        expect(RecipeIngredient.last.measurement_unit.name).to eq(new_measurement_unit_name)
      end

      it 'gets an error if trying to create an already existing ingredient' do
        existing_ingredient = create(:ingredient)
        existing_measurement_unit = create(:measurement_unit)

        visit new_recipe_path

        find('label', text: I18n.t('helpers.ai_tools.use_ai')).click

        fill_in RecipeIngredient.human_attribute_name(:quantity), with: 10
        smart_select(existing_ingredient.name,
                     from: RecipeIngredient.human_attribute_name(:ingredient),
                     wrapper_css_selector: '.col', create: true)
        expect(page).to have_content(I18n.t('helpers.errors.create', model: Ingredient.model_name.human))
        smart_select(existing_measurement_unit.name,
                     from: RecipeIngredient.human_attribute_name(:measurement_unit_short),
                     wrapper_css_selector: '.col', create: true)
        expect(page).to have_content(I18n.t('helpers.errors.create', model: MeasurementUnit.model_name.human))
      end

      it 'can manually create recipe steps' do
        visit new_recipe_path

        fill_in Recipe.human_attribute_name(:title), with: 'My Title'
        fill_in Recipe.human_attribute_name(:description), with: 'My Description'

        find('label', text: I18n.t('helpers.ai_tools.use_ai')).click

        expect(page).to have_content(RecipeStep.model_name.human.pluralize)

        within('.recipe__steps_panel') do
          fill_in RecipeStep.human_attribute_name(:instruction), with: 'My Instruction'
          fill_in RecipeStep.human_attribute_name(:description), with: 'My Longer Description'
          fill_in RecipeStep.human_attribute_name(:step_number), with: 1

          find("button[title='#{I18n.t('forms.add_new')}']").click

          expect(all('label', text: RecipeStep.human_attribute_name(:step_number)).count).to eq(2)

          within('.nested-recipe-step-wrapper:nth-of-type(2)') do
            fill_in RecipeStep.human_attribute_name(:instruction), with: 'My Instruction 2'
            fill_in RecipeStep.human_attribute_name(:description), with: 'My Longer Description 2'
            fill_in RecipeStep.human_attribute_name(:step_number), with: 2
          end
        end

        expect do
          click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
          expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
        end.to change(RecipeStep, :count).by(2)
      end
    end
  end
end
