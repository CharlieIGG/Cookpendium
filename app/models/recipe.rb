class Recipe < ApplicationRecord
  translates :title, :description

  validates :title, presence: true
  validates :description, presence: true
end
