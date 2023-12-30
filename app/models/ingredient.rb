class Ingredient < ApplicationRecord
  translates :name

  validates :name, presence: true
end
