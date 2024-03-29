require 'rails_helper'

RSpec.describe AITools::MeasurementUnitAbbreviator, type: :service do
  describe '#call' do
    context 'when a valid measurement unit is passed' do
      it 'returns the abbreviation of the measurement unit' do
        VCR.use_cassette('measurement_unit_abbreviator/tablespoon') do
          result = AITools::MeasurementUnitAbbreviator.call('tablespoon')
          expect(result).to eq('tbsp')
        end
      end
    end

    context 'when an invalid measurement unit is passed' do
      context 'when the measurement unit is not a string' do
        it 'raises an ArgumentError' do
          expect { AITools::MeasurementUnitAbbreviator.call(1) }.to raise_error(ArgumentError)
          expect { AITools::MeasurementUnitAbbreviator.call([]) }.to raise_error(ArgumentError)
          expect { AITools::MeasurementUnitAbbreviator.call({}) }.to raise_error(ArgumentError)
        end
      end

      context 'when the measurement unit is less than four characters long' do
        it 'returns the original measurement unit' do
          result = AITools::MeasurementUnitAbbreviator.call('cup')
          expect(result).to eq('cup')
        end
      end
    end
  end
end
