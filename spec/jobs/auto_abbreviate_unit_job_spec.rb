require 'rails_helper'

RSpec.describe AutoAbbreviateUnitJob, type: :job do
  describe '#perform' do
    let!(:measurement_unit) { create(:measurement_unit, :without_abbreviation) }

    it 'calls #auto_abbreviate on the unit' do
      allow(measurement_unit).to receive(:auto_abbreviate)
      expect(MeasurementUnit).to receive(:find).with(measurement_unit.id).and_return(measurement_unit)
      expect(measurement_unit).to receive(:auto_abbreviate)

      AutoAbbreviateUnitJob.perform_now(measurement_unit.id, locale: 'en')
    end
  end
end
