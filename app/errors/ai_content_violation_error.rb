# frozen_string_literal: true

# Error class to communicate to the user that the content they are trying to
# submit violates the AI content policy
class AiContentViolationError < StandardError
  def message
    I18n.t('helpers.errors.ai.content_policy_violation')
  end
end
