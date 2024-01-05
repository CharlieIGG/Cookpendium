# frozen_string_literal: true

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
class MeasurementUnit < ApplicationRecord
  translates :name, :abbreviation

  validates :name, presence: true
end
