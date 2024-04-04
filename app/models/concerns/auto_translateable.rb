# frozen_string_literal: true

# This concern provides a way to automatically translate the fields of a model
# that implements translations using Globalize.
module AutoTranslateable
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    after_commit :check_for_translateable_changes, on: %i[update]
    after_commit :auto_translate_later

    attr_accessor :overwrite_translations

    def check_for_translateable_changes
      self.overwrite_translations = previous_changes.keys.any? do |attr|
        self.class.translated_attribute_names.include?(attr.to_sym)
      end
    end

    def auto_translate
      target_locales = target_translation_locales
      target_attributes = translateable_attributes
      return if target_locales.empty? || target_attributes.empty?

      translated_attributes = AITools::AutoTranslator.call(
        target_attributes, target_locales:,
                           source_locale: I18n.locale
      )
      ActiveRecord::Base.transaction do
        translated_attributes.each do |locale, attributes|
          update!(**attributes, locale:)
        end
      end
    end

    def auto_translate_later
      AutoTranslateJob.perform_later(id, model_name.to_s, source_locale: I18n.locale.to_s,
                                                          overwrite: overwrite_translations)
    end

    def target_translation_locales
      return I18n.available_locales - [I18n.locale] if overwrite_translations

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
