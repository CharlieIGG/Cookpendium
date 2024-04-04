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
class GrocerySection < ApplicationRecord
  include AutoTranslateable

  translates :name, :description

  validates :name, presence: true
end
