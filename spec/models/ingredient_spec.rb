# == Schema Information
#
# Table name: ingredients
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  grocery_section_id :bigint
#
# Indexes
#
#  index_ingredients_on_grocery_section_id  (grocery_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (grocery_section_id => grocery_sections.id)
#
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
