# == Schema Information
#
# Table name: recipe_steps
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  instruction :text
#  step_number :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :recipe_step do
    sequence(:step_number) { |n| n }
    instruction { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    recipe

    trait :with_ingredients do
      transient do
        ingredients_count { 3 }
      end

      after(:create) do |recipe_step, evaluator|
        create_list(:ingredient, evaluator.ingredients_count).each do |ingredient|
          create_list(:recipe_step_ingredient, evaluator.ingredients_count, recipe_step:, ingredient:)
        end
      end
    end
    trait :with_ingredients_and_measurements do
      transient do
        ingredients_count { 3 }
      end

      after(:create) do |recipe_step, evaluator|
        create_list(:ingredient, evaluator.ingredients_count).each do |ingredient|
          create_list(:recipe_step_ingredient, :with_measurements, evaluator.ingredients_count, recipe_step:,
                                                                                                ingredient:)
        end
      end
    end
  end
end
