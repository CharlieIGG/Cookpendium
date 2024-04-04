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
require 'rails_helper'

RSpec.describe MeasurementUnit, type: :model do
  it { should validate_presence_of(:name) }

  it 'should automatically call the auto_translate_later method after creating or updating' do
    expect do
      create(:measurement_unit)
    end.to have_enqueued_job(AutoTranslateJob).with(kind_of(Integer), 'MeasurementUnit', source_locale: 'en',
                                                                                         overwrite: nil)
    expect(subject).to receive(:auto_translate_later)
    subject.update!(name: 'A different name', abbreviation: 'A varied abbreviation')
  end

  context 'after saving' do
    it 'calls auto_abbreviate_later before calling auto_translate_later' do
      expect do
        create(:measurement_unit, :without_abbreviation)
      end.to have_enqueued_job(AutoAbbreviateUnitJob).with(kind_of(Integer), locale: I18n.locale)
    end
  end

  describe 'auto_abbreviate' do
    context 'when abbreviations are missing' do
      it 'calls AITools::MeasurementUnitAbbreviator' do
        unit = create(:measurement_unit, :without_abbreviation)
        expect(AITools::MeasurementUnitAbbreviator).to receive('call').with(unit.name, locale: I18n.locale)
        unit.auto_abbreviate
      end
    end

    context 'when abbreviations are present' do
      it 'does not call AITools::MeasurementUnitAbbreviator' do
        unit = create(:measurement_unit)
        expect(AITools::MeasurementUnitAbbreviator).not_to receive('call')
        unit.auto_abbreviate
      end
    end
  end

  describe 'auto_abbreviate_later' do
    it 'enqueues a job to call auto_abbreviate' do
      unit = create(:measurement_unit, :without_abbreviation)

      expect do
        unit.auto_abbreviate_later
      end.to have_enqueued_job(AutoAbbreviateUnitJob).with(unit.id, locale: I18n.locale)
    end
  end
end
