# spec/models/recipe_step_spec.rb
require "rails_helper"

RSpec.describe RecipeStep, type: :model do
  it { should validate_presence_of(:instruction) }

  it "is translatable" do
    recipe = FactoryBot.create(:recipe)
    recipe_step = RecipeStep.create!(recipe: recipe, instruction: "Mix the {{ingredient_name}} into the bowl")
    I18n.locale = :de
    expect(recipe_step.instruction).to eq(nil)
    recipe_step.update!(instruction: "Mische {{ingredient_name}} in die Schüssel")
    I18n.locale = :en
    expect(recipe_step.instruction).to eq("Mix the {{ingredient_name}} into the bowl")
  end

  it "has a valid factory" do
    expect(FactoryBot.build(:recipe_step)).to be_valid
  end
end
