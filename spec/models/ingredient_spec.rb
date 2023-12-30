# spec/models/ingredient_spec.rb
require "rails_helper"

RSpec.describe Ingredient, type: :model do
  it { should validate_presence_of(:name) }

  it "is translatable" do
    ingredient = Ingredient.create!(name: "Carrot")
    I18n.locale = :de
    expect(ingredient.name).to eq(nil)
    ingredient.update!(name: "Karotte")
    I18n.locale = :en
    expect(ingredient.name).to eq("Carrot")
  end
end
