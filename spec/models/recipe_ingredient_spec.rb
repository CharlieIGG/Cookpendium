# spec/models/recipe_ingredient_spec.rb
require "rails_helper"

RSpec.describe RecipeIngredient, type: :model do
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:unit) }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }

  it "should validate that unit is one of the valid enum values in the 'Measurable' concern" do
    recipe = Recipe.create!(title: "Pancakes", description: "A delicious breakfast treat")
    ingredient = Ingredient.create!(name: "Flour")
    expect { RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit: "invalid") }.to raise_error(ArgumentError)
    expect { RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit: "cups") }.not_to raise_error
  end
end
