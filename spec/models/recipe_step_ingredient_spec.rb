# spec/models/recipe_ingredient_spec.rb
require 'rails_helper'

RSpec.describe RecipeStepIngredient, type: :model do
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }
  it { should belong_to(:measurement_unit) }
end
