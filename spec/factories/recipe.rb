# spec/factories/recipes.rb
FactoryBot.define do
    factory :recipe do
        title { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
    end
end