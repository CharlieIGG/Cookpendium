class RecipeStep < ApplicationRecord
  belongs_to :recipe
  translates :instruction
end
