# frozen_string_literal: true

class BaseDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper
end
