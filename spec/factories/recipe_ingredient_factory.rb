FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    trait :with_measurements do
      association :measurement_unit
      quantity { Faker::Number.decimal(l_digits: 2) }
    end
  end
end
