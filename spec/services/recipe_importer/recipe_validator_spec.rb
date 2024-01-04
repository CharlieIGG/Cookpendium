require 'rails_helper'

RSpec.describe RecipeImporter::RecipeValidator, type: :service do
  describe '#valid?' do
    context 'when a valid recipe is passed' do
      recipe_hash = YAML.load_file('spec/fixtures/recipe_hash.yaml')
      validator = RecipeImporter::RecipeValidator.new(recipe_hash)
      it 'returns true' do
        expect(validator.valid?).to be_truthy
      end
    end
  end
end
