# frozen_string_literal: true

module AITools
  # This AutoTranslator takes a hash of attributes for a model, and translates them using OpenAI
  class AutoTranslator < ApplicationService
    attr_reader :attributes, :target_locales, :source_locale, :model_name, :client

    def initialize(attributes, target_locales:, source_locale: :en, model_name: nil, client: OpenAI::Client.new)
      @attributes = attributes
      @target_locales = target_locales
      @source_locale = source_locale
      @model_name = model_name
      @client = client
    end

    def call
      translate
    end

    private

    def translate
      client.chat(
        parameters: {
          model: 'gpt-3.5-turbo-1106',
          response_format: { type: 'json_object' },
          messages: assistant_messages,
          temperature: 0.5
        }
      )
    end

    def assistant_messages
      [
        { role: 'system',
          content: "Translate the following #{model_name} to the following ISO 639-1 languages: #{target_locales.join(',')}." },
        { role: 'system',
          content: 'Return the translation as a JSON object, with the root containing the ISO 639-1 language code. '\
                   'Each key value should be an object with the translated attributes for the corresponding language' },
        { role: 'system', content: attributes }
      ]
    end
  end
end
