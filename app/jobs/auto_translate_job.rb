# frozen_string_literal: true

# takes in the ID of a model that implement #auto_translate, and calls it.
class AutoTranslateJob < ApplicationJob
  queue_as :default

  def perform(model_id, class_name, locale)
    I18n.with_locale(locale) do
      model = class_name.constantize.find(model_id)
      model.auto_translate
    end
  end
end
