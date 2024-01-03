# frozen_string_literal: true

# this model is used to store the measurement units for cooking, such as grams, cups, etc.
class MeasurementUnit < ApplicationRecord
  translates :name, :abbreviation

  validates :name, presence: true
end
