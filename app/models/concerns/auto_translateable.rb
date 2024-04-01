# frozen_string_literal: true

# This concern provides a way to automatically translate the fields of a model
# that implements translations using Globalize.
module AutoTranslateable
  extend ActiveSupport::Concern

  included do
    after_commit :auto_translate_later

    def auto_translate
      target_locales = target_translation_locales
      target_attributes = translateable_attributes
      return if target_locales.empty? || target_attributes.empty?

      translated_attributes = AITools::AutoTranslator.call(
        target_attributes, target_locales:,
                           source_locale: I18n.locale
      )
      update!(translated_attributes)
    end

    def auto_translate_later
      AutoTranslateJob.perform_later(id, model_name.to_s)
    end

    def target_translation_locales
      I18n.available_locales - translations.pluck(:locale).map(&:to_sym)
    end

    def translateable_attributes
      translateable_fields = self.class.translated_attribute_names
      translateable_fields.each_with_object({}) do |field, result|
        translated_value = send(field)
        next result if translated_value.nil? || translated_value.empty?

        result[field] = translated_value
      end
    end
  end
end
