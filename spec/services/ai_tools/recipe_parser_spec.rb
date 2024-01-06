require 'rails_helper'

RSpec.describe AITools::RecipeParser, type: :service do # rubocop:disable Metrics/BlockLength
  describe '#parse' do # rubocop:disable Metrics/BlockLength
    context 'when a proper text is entered' do
      it 'returns a valid JSON representing a recipe' do
        VCR.use_cassette('recipe_parser/valid_recipe') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt'))
          parser = AITools::RecipeParser.new(input_text)
          result = parser.parse
          expect(result).to be_a(Hash)
          expect(result).to include('title', 'description', 'ingredients', 'recipe_steps', 'locale')
        end
      end
    end

    context 'when the input text is not a valid recipe' do
      it 'returns a JSON with an error message' do
        VCR.use_cassette('recipe_parser/invalid_recipe') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'invalid_raw_recipe.txt'))
          parser = AITools::RecipeParser.new(input_text)
          result = parser.parse
          expect(result).to be_a(Hash)
          expect(result).to include('error')
        end
      end
    end

    context 'returning the recipe in the locale the request was initiated from' do
      it 'returns a JSON with the recipe in the locale the request was initiated from' do
        VCR.use_cassette('recipe_parser/valid_recipe_in_german') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe_german.txt'))
          parser = AITools::RecipeParser.new(input_text, locale: 'en')
          result = parser.parse
          expect(result).to be_a(Hash)
          expect(result).to include('title', 'description', 'ingredients', 'recipe_steps', 'locale')
          expect(result['title']).to eq('Potato Salad')
        end
      end
    end
  end
end