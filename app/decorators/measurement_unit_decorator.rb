# frozen_string_literal: true

# Encapsulates representational logic for rendering a MeasurementUnit
class MeasurementUnitDecorator < BaseDecorator
  def full_label
    return name unless abbreviation.present?

    "#{name} (#{abbreviation})"
  end
end
