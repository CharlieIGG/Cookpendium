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
FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
  end
end
