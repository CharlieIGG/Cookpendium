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
      # This is a fake translator service, it just returns the same attributes
      @attributes
    end
  end
end
