# == Schema Information
#
# Table name: measurement_units
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :measurement_unit do
    sequence(:name) { |n| "#{Faker::Measurement.weight} #{n}" }
    sequence(:abbreviation) { |n| "#{Faker::Measurement.weight} #{n}" }

    trait :without_abbreviation do
      abbreviation { nil }
    end
  end
end
