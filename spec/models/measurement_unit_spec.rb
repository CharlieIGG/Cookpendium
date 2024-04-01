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
    end.to have_enqueued_job(AutoTranslateJob).with(kind_of(Integer), 'MeasurementUnit')
    expect(subject).to receive(:auto_translate_later)
    subject.update!(name: 'A different name', abbreviation: 'A varied abbreviation')
  end
end
