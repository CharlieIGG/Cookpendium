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
