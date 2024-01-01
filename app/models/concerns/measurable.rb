# Concern for models that have a unit of measurement
module Measurable
  extend ActiveSupport::Concern

  included do
    enum unit: MeasuringUnits::UNITS
  end
end
