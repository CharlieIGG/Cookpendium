# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'My Recipes', type: :system do
  let(:user) { create(:user) }
  let!(:author_recipe) { create(:recipe, :with_ingredients, :with_steps, author: user) }
  let!(:other_recipe) { create(:recipe, :with_ingredients, :with_steps) }

  before do
    login_as(user)
    visit root_path
  end

  it 'displays only the recipes for which the user is the author' do
    click_link I18n.t('recipes.my_recipes')
    expect(page).to have_content(author_recipe.title)
    expect(page).not_to have_content(other_recipe.title)
  end

  context 'with search criteria' do
    let(:target_recipe) { create(:recipe, :with_ingredients, :with_steps, author: user) }
    let!(:ingredient1) { create(:ingredient, name: 'chickpeas') }

    before do
      target_recipe.ingredients << ingredient1
    end

    it 'displays only the recipes for which the user is the author and match the search criteria' do
      click_link I18n.t('recipes.my_recipes')
      fill_in 'search_text', with: 'chickpeas'
      within '#recipes' do
        click_button 'Search'
      end
      expect(page).to have_content(target_recipe.title)
      expect(page).not_to have_content(author_recipe.title)
      expect(page).not_to have_content(other_recipe.title)
    end

    context 'for recipes without steps or ingredients' do
      context 'for the user\'s own recipes' do
        let!(:draft_recipe) { create(:recipe, author: user) }
        it 'shows the recipes with a "draft" badge' do
          click_link I18n.t('recipes.my_recipes')
          expect(page).to have_content(draft_recipe.title)
          expect(page).to have_css('.badge', text: I18n.t('recipes.draft'))
        end
      end
    end
  end
end
