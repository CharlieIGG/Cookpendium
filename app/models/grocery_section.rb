class GrocerySection < ApplicationRecord
  translates :name, :description

  validates :name, presence: true
end
