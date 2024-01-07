# == Schema Information
#
# Table name: recipe_step_ingredients
#
#  id                  :bigint           not null, primary key
#  quantity            :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ingredient_id       :bigint           not null
#  measurement_unit_id :bigint
#  recipe_step_id      :bigint           not null
#
# Indexes
#
#  index_recipe_step_ingredients_on_ingredient_id        (ingredient_id)
#  index_recipe_step_ingredients_on_measurement_unit_id  (measurement_unit_id)
#  index_recipe_step_ingredients_on_recipe_step_id       (recipe_step_id)
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (measurement_unit_id => measurement_units.id)
#  fk_rails_...  (recipe_step_id => recipe_steps.id)
#
FactoryBot.define do
  factory :recipe_step_ingredient do
    association :recipe_step
    association :ingredient
    quantity { 1 }

    trait :with_measurements do
      association :measurement_unit
    end
  end
end
