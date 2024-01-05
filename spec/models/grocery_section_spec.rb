# == Schema Information
#
# Table name: grocery_sections
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# spec/models/grocery_section_spec.rb
require "rails_helper"

RSpec.describe GrocerySection, type: :model do
  it { should validate_presence_of(:name) }

  it "is translatable" do
    section = GrocerySection.create!(name: "Produce", description: "Fruits and vegetables")
    I18n.locale = :de
    expect(section.name).to eq(nil)
    section.update!(name: "Obst und Gemüse", description: "Früchte und Gemüse")
    I18n.locale = :en
    expect(section.name).to eq("Produce")
  end
end
