# frozen_string_literal: true

require 'openai'

module AITools
  class MeasurementUnitAbbreviator < ApplicationService
    attr_reader :measurement_unit, :client, :locale

    def initialize(measurement_unit, locale: 'en', client: OpenAI::Client.new)
      @measurement_unit = measurement_unit
      @locale = locale
      @client = client
    end

    def call
      raise ArgumentError, 'Measurement unit must be a string' unless measurement_unit.is_a?(String)
      return measurement_unit if measurement_unit.length < 4

      generate_abbreviation
    end

    private

    def generate_abbreviation
      response = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo-1106',
          messages: [
            { role: 'system', content: system_instructions },
            { role: 'user', content: measurement_unit }
          ]
        }
      )
      response.dig('choices', 0, 'message', 'content')
    end

    def system_instructions
      <<~HEREDOC.freeze
        Please provide the abbreviation for the following measurement unit used in a cooking recipe.
        the measurement unit is in #{locale} please return the abbreviation in the same language.
        If you think that the unit is already abbreviated, then return the same string back.
      HEREDOC
    end
  end
end
