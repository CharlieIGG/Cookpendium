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
    abbreviation { Faker::Measurement.weight }
  end
end
