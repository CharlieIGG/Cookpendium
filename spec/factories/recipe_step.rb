FactoryBot.define do
    factory :recipe_step do
        # Define your factory attributes here
        sequence(:step_number) { |n| n }
        instruction { Faker::Lorem.sentence }
        recipe
    end
end
