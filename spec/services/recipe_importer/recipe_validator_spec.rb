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

    context 'when an invalid recipe is passed' do
      it 'returns false if title is missing' do
        recipe_hash = {}
        validator = RecipeImporter::RecipeValidator.new(recipe_hash)
        expect(validator.valid?).to be_falsey
      end
      it 'returns false if ingredients are missing or empty' do
        recipe_hash = { 'title' => 'test', 'description' => 'test' }
        expect(RecipeImporter::RecipeValidator.new(recipe_hash).valid?).to be_falsey

        recipe_hash = recipe_hash.merge('ingredients' => [])
        expect(RecipeImporter::RecipeValidator.new(recipe_hash).valid?).to be_falsey
      end
    end
  end
end
