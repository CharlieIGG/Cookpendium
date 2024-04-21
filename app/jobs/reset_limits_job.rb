# frozen_string_literal: true

# Job to reset usage limits for all users
class ResetLimitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.reset_ai_limits!
  end
end
