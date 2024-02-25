# frozen_string_literal: true

module AITools
  # Service to generate an image from a prompt using an AI generator (DALL-E by default)
  class ImageGenerator < ApplicationService
    DEFAULT_MODEL = 'dall-e-3'

    def initialize(prompt, client: OpenAI::Client.new, model: nil)
      @prompt = prompt
      @client = client
      @model = model || DEFAULT_MODEL
    end

    def call
      response = @client.images.generate(parameters: { prompt: @prompt, model: @model })
      response.dig('images', 0, 'image')
    rescue Faraday::BadRequestError => e
      raise AiContentViolationError if e.response.dig(:body, 'error', 'code') == 'content_policy_violation'

      raise e
    end
  end
end
