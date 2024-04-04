require 'rails_helper'

RSpec.describe AITools::RecipeParser, type: :service do
  describe '#call' do
    context 'when a proper text is entered' do
      it 'returns a valid JSON representing a recipe' do
        VCR.use_cassette('recipe_parser/valid_recipe') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe.txt'))
          result = AITools::RecipeParser.call(input_text)
          expect(result).to be_a(Hash)
          expect(result).to include('title', 'description', 'ingredients', 'recipe_steps', 'locale')
        end
      end
    end

    context 'when the input text is not a valid recipe' do
      it 'returns a JSON with an error message' do
        VCR.use_cassette('recipe_parser/invalid_recipe') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'invalid_raw_recipe.txt'))
          result = AITools::RecipeParser.call(input_text)
          expect(result).to be_a(Hash)
          expect(result).to include('error')
        end
      end
    end

    context 'returning the recipe in the locale the request was initiated from' do
      it 'returns a JSON with the recipe in the locale the request was initiated from' do
        VCR.use_cassette('recipe_parser/valid_recipe_in_german') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe_german.txt'))
          result = AITools::RecipeParser.call(input_text, locale: 'en')
          expect(result).to be_a(Hash)
          expect(result).to include('title', 'description', 'ingredients', 'recipe_steps', 'locale')
          expect(result['title']).to eq('Potato Salad')
        end
      end
    end

    context 'returns additional information about the recipe if present in the input text' do
      it 'returns a JSON with the recipe in the locale the request was initiated from' do
        VCR.use_cassette('recipe_parser/valid_recipe_with_additional_info') do
          input_text = File.read(Rails.root.join('spec', 'fixtures', 'valid_raw_recipe_with_additional_info.txt'))
          result = AITools::RecipeParser.call(input_text)
          expect(result).to be_a(Hash)
          expect(result).to include('prep_time_minutes', 'cooking_time_minutes', 'serving_unit', 'servings', 'vegan',
                                    'vegetarian')
          expect(result['prep_time_minutes']).to eq(25)
          expect(result['cooking_time_minutes']).to eq(40)
          expect(result['serving_unit']).to eq('cookies')
          expect(result['servings']).to eq(30)
          expect(result['vegan']).to eq(false)
          expect(result['vegetarian']).to eq(true)
        end
      end
    end
  end
end
