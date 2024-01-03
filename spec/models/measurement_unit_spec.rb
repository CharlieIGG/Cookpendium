require 'rails_helper'

RSpec.describe MeasurementUnit, type: :model do
  it { should validate_presence_of(:name) }
end
