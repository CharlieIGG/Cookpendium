require 'rails_helper'

RSpec.describe 'Create Recipes', type: :system do # rubocop:disable Metrics/BlockLength
  describe 'creating recipes requires authentication' do
    it 'redirects to login page' do
      visit new_recipe_path
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  describe 'creating new recipe via Form Fields' do # rubocop:disable Metrics/BlockLength
    let_it_be(:user) { create(:user) }

    before(:each) do
      login_as user
    end

    describe 'using a raw text recipe (AI Tools)' do # rubocop:disable Metrics/BlockLength
      it 'can create a new recipe out of a raw text recipe' do
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt'))
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
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt'))
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
        ingredients_and_instructions = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt'))
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
    end
  end
end
