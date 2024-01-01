# frozen_string_literal: true

# Single source of truth service for measuring units
module MeasuringUnits
  UNITS = {
    grams: 0,
    kilograms: 1,
    ounces: 2,
    pounds: 3,
    milliliters: 4,
    liters: 5,
    teaspoons: 6,
    tablespoons: 7,
    cups: 8,
    pints: 9,
    quarts: 10,
    gallons: 11,
    pieces: 12,
    slices: 13,
    leaves: 14,
    pinches: 15,
    dashes: 16
  }.freeze
end
