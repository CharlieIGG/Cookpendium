# frozen_string_literal: true

module AITools
  # contains the instructions necessary for the AI assistant to parse a recipe
  class RecipeParserInstructions
    def initialize(locale:)
      @locale = locale
    end

    def sanity_filter_instructions
      <<~HEREDOC
        If the provided text is not a cooking recipe, please return the following JSON object:
        {
            "error": "The provided text is not a recipe. Please provide a recipe."
        }
      HEREDOC
    end

    def ingredient_structure_instructions
      <<~HEREDOC
        -- ingredient name (string). Do not include any units or quantities in the name.
        -- quantity (number)
        -- unit (string), as standard as possible, such as 'grams', 'cups', 'pinches', 'tablespoons', 'teaspoons', 'pounds', 'ounces', etc.
      HEREDOC
    end

    def recipe_step_structure_instructions
      <<~HEREDOC
        -- a description (string): the detailed description on how to complete the instruction (e.g. "Preheat the oven to 350 degrees Fahrenheit")
        -- an instruction (string): a short sentence thath summarizes the step in 45 characters or less (e.g. "Preheat the oven")
        --- Note: the "instruction" is a supposed to be a shortened version of the "description" that can be used as a title for the step.
        -- a step_number (integer), indicating the order of the step
        -- a list of ingredients, as an array of objects, with the same structure as the main ingredients array.
        -- only list ingredients that are used in their original form (i.e. omit ingredients that have already been mixed or transformed in previous steps)
      HEREDOC
    end

    def recipe_step_splitting_instructions
      <<~HEREDOC
        If a recipe step contains multiple actions in any part of the original text, please split them into separate recipe_steps.
        Typically this is identified by the word "and" or a comma between two actions (verbs).
        Also if instructions are given in a paragraph separated by periods, please split them into separate recipe_steps.
      HEREDOC
    end

    def locale_detection_instructions
      <<~HEREDOC
        Please ensure that you return the recipe in #{I18n.t("languages.#{@locale}")} \
        regardless of the language the recipe was written in. This means you might \
        have to translate the recipe into #{I18n.t("languages.#{@locale}")}.
        Ensure you translate the title, the ingredients, and the recipe steps.
      HEREDOC
    end

    def recipe_structure_instructions
      <<~HEREDOC.freeze
        Take the following text and parse it into a JSON recipe object.
        The recipe object should have the following attributes:
        - title
        - description
        - ingredients, as an array of objects, each including:
        #{ingredient_structure_instructions}
        - recipe_steps, as an array of objects, each containing:
        #{recipe_step_structure_instructions}

        #{recipe_step_splitting_instructions}
      HEREDOC
    end
  end
end
