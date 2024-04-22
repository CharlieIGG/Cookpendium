# == Schema Information
#
# Table name: recipes
#
#  id                   :bigint           not null, primary key
#  cooking_time_minutes :integer
#  description          :text             not null
#  prep_time_minutes    :integer
#  serving_unit         :string
#  servings             :integer
#  title                :string           not null
#  vegan                :boolean
#  vegetarian           :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :recipe do # rubocop:disable Metrics/BlockLength
    sequence(:title) { |n| "#{Faker::Lorem.unique.word} #{n}" }
    description { Faker::Lorem.paragraph }

    transient do
      author { nil }
    end

    after(:create) do |recipe, evaluator|
      evaluator.author.add_role(:author, recipe) if evaluator.author.present?
    end

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
          create_list(:recipe_ingredient, evaluator.ingredients_count, ingredient:, recipe:)
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
