# frozen_string_literal: true

# takes in the ID of a measurement_unit that implement #auto_translate, and calls it.
class AutoAbbreviateUnitJob < ApplicationJob
  queue_as :default

  def perform(measurement_unit_id, locale:)
    I18n.with_locale(locale) do
      measurement_unit = MeasurementUnit.find(measurement_unit_id)
      return unless measurement_unit

      measurement_unit.auto_abbreviate
    end
  end
end
