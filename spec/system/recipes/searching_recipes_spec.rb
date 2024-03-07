require 'rails_helper'

RSpec.describe 'Searching Recipes', type: :system do
  let!(:recipe1) { create(:recipe, :with_steps, title: 'Spaghetti Bolognese', description: 'Classic Italian dish') }
  let!(:recipe2) { create(:recipe, :with_steps, title: 'Chicken Curry', description: 'Delicious Indian curry') }
  let!(:ingredient0) { create(:ingredient, name: 'salt') }
  let!(:ingredient1) { create(:ingredient, name: 'spaghetti') }
  let!(:ingredient2) { create(:ingredient, name: 'tomato sauce') }
  let!(:ingredient3) { create(:ingredient, name: 'ground beef') }
  let!(:ingredient4) { create(:ingredient, name: 'chicken') }
  let!(:ingredient5) { create(:ingredient, name: 'curry powder') }

  before do
    recipe1.ingredients << [ingredient0, ingredient1, ingredient2, ingredient3]
    recipe2.ingredients << [ingredient0, ingredient4, ingredient5]
  end

  it 'searches recipes by search_text' do
    visit recipes_path
    fill_in 'search_text', with: 'spaghetti'
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).to have_content(recipe1.title)
    expect(page).not_to have_content(recipe2.title)
  end

  it 'only matches words STARTING with the search_text' do
    visit recipes_path
    fill_in 'search_text', with: 'sal' # both recipes have salt
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).to have_content(recipe1.title)
    expect(page).to have_content(recipe2.title)

    fill_in 'search_text', with: 'ian' # both recipes have "ian" in "Italian" and "Indian"
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).not_to have_content(recipe1.title)
    expect(page).not_to have_content(recipe2.title)
  end

  it 'searches recipes by search_text (case insensitive)' do
    visit recipes_path
    fill_in 'search_text', with: 'SPAGHETTI'
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).to have_content(recipe1.title)
    expect(page).not_to have_content(recipe2.title)
  end

  it 'searches recipes by search_ingredient_ids' do
    visit recipes_path
    select ingredient4.name, from: 'search_ingredient_ids'
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).not_to have_content(recipe1.title)
    expect(page).to have_content(recipe2.title)

    select ingredient0.name, from: 'search_ingredient_ids'
    within '#recipes' do
      click_button 'Search'
    end
    expect(page).to have_content(recipe1.title)
    expect(page).to have_content(recipe2.title)
  end
end
