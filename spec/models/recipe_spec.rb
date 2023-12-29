# spec/models/recipe_spec.rb
require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'is translatable' do
    recipe = Recipe.create!(title: 'Fruit Salad', description: 'A delicious fruit salad')
    I18n.locale = :de
    expect(recipe.title).to eq(nil)
    recipe.update!(title: 'Obstsalat', description: 'Ein leckerer Obstsalat')
    I18n.locale = :en
    expect(recipe.title).to eq('Fruit Salad')
  end
end
