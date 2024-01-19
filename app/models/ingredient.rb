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
class Ingredient < ApplicationRecord
  translates :name

  validates :name, presence: true, uniqueness: true

  scope :by_name, -> { order(:name) }
end
