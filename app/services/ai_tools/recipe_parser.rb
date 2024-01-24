# frozen_string_literal: true

module AITools
  # Service to parse a structured recipe and it's associations from a raw text
  class RecipeParser < ApplicationService
    SYSTEM_ROLE = 'system'
    USER_ROLE = 'user'

    def initialize(raw_text, locale: 'en', client: OpenAI::Client.new)
      @raw_text = raw_text
      @client = client
      @locale = locale
    end

    def call
      result = parse_with_openai
      JSON.parse(result).merge('locale' => @locale)
    rescue JSON::ParserError => e
      handle_json_parse_error(e)
    end

    private

    def default_parameters
      {
        model: 'gpt-3.5-turbo-1106',
        response_format: { type: 'json_object' },
        messages: assistant_messages,
        temperature: 0.5
      }
    end

    def assistant_messages
      instructions = RecipeParserInstructions.new(locale: @locale)
      [
        { role: SYSTEM_ROLE, content: instructions.recipe_structure_instructions },
        { role: SYSTEM_ROLE, content: instructions.sanity_filter_instructions },
        { role: SYSTEM_ROLE, content: instructions.locale_detection_instructions },
        { role: SYSTEM_ROLE, content: instructions.additional_data_instructions },
        { role: USER_ROLE, content: @raw_text }
      ]
    end

    def parse_with_openai
      response = @client.chat(
        parameters: default_parameters
      )
      response.dig('choices', 0, 'message', 'content')
    end

    def handle_json_parse_error(error)
      Rails.logger.error("Failed to parse OpenAI response: #{error.message}")
      { error: 'Failed to parse OpenAI response. Please try again.' }
    end
  end
end
