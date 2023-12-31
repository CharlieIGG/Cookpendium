module OpenAI
  class RecipeParser
    def initialize(raw_text)
      @raw_text = raw_text
      @client = OpenAI::Client.new
      @response = nil
    end

    def parse
      recipe_object = parse_with_openai

      # Create and return the recipe object
      #   OpenStruct.new(
      #     title:,
      #     description: nil,
      #     ingredients:,
      #     recipe_steps:
      #   )
      puts recipe_object
    end

    private

    def default_parameters
      {
        model: 'gpt-3.5-turbo-1106',
        response_format: { type: 'json_object' },
        messages: [
          { role: 'system', content: assistant_system_instructions },
          { role: 'user', content: @raw_text }
        ],
        temperature: 0.5
      }
    end

    def assistant_system_instructions
      <<~HEREDOC
        Take the following text and parse it into a JSON recipe object.
        The recipe object should have the following attributes:
        - title
        - description
        - ingredients (as an array of objects, each including the ingredient name, quantity, and unit)
        - recipe_steps (as an array of objects, each containing an instruction, and a list of ingredients)
        Please ensure that the ingredients nested inside the recipe_steps are the same objects as the ones in the ingredients array.
      HEREDOC
    end

    def parse_with_openai
      response = @client.chat(
        parameters: default_parameters
      )
      response.dig('choices', 0, 'message', 'content')
    end
  end
end
