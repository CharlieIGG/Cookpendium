# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetLimitsJob, type: :job do
  it 'calls reset_ai_limits on User' do
    expect(User).to receive(:reset_ai_limits!)
    ResetLimitsJob.perform_now
  end
end
