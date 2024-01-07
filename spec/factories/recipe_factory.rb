# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# spec/factories/recipes.rb
FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :recipe do # rubocop:disable Metrics/BlockLength
    sequence(:title) { |n| "#{Faker::Lorem.unique.word} #{n}" }
    description { Faker::Lorem.paragraph }

    trait :with_steps do
      transient do
        steps_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:recipe_step, evaluator.steps_count, recipe:)
      end
    end

    trait :with_steps_and_step_ingredients do
      transient do
        steps_count { 3 }
      end
      after(:create) do |recipe, evaluator|
        create_list(:recipe_step, evaluator.steps_count, :with_ingredients, recipe:)
      end
    end

    trait :with_steps_and_step_ingredients_with_measurements do
      transient do
        steps_count { 3 }
      end
      after(:create) do |recipe, evaluator|
        create_list(:recipe_step, evaluator.steps_count, :with_ingredients, recipe:)
      end
    end

    trait :with_ingredients do
      transient do
        ingredients_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:ingredient, evaluator.ingredients_count).each do |ingredient|
          create_list(:recipe_step_ingredient, evaluator.ingredients_count,
                      recipe_step: recipe.recipe_steps.first, ingredient:)
        end
      end
    end
    trait :with_ingredients_and_measurements do
      transient do
        ingredients_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:ingredient, evaluator.ingredients_count).each do |ingredient|
          create(:recipe_ingredient, :with_measurements, recipe:, ingredient:)
        end
      end
    end
  end
end
