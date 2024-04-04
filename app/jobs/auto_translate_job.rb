# frozen_string_literal: true

# takes in the ID of a model that implement #auto_translate, and calls it.
class AutoTranslateJob < ApplicationJob
  queue_as :default

  def perform(model_id, class_name, source_locale:, overwrite: false)
    I18n.with_locale(source_locale) do
      model = class_name.constantize.find(model_id)
      model.overwrite_translations = overwrite
      model.auto_translate
    end
  end
end
