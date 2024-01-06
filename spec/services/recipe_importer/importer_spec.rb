require 'rails_helper'

RSpec.describe RecipeImporter::Importer, type: :service do # rubocop:disable Metrics/BlockLength
  describe '#import' do # rubocop:disable Metrics/BlockLength
    context 'when a valid recipe is passed' do
      recipe_hash = YAML.load_file('spec/fixtures/recipe_hash.yaml')
      importer = RecipeImporter::Importer.new(recipe_hash)
      it 'creates a recipe' do
        expect { importer.import }.to change(Recipe, :count).by(1)
      end
      it 'creates ingredients' do
        expect { importer.import }.to change(Ingredient, :count).by(9)
      end
      it 'creates recipe ingredients' do
        expect { importer.import }.to change(RecipeIngredient, :count).by(9)
      end
      it 'creates recipe steps' do
        expect { importer.import }.to change(RecipeStep, :count).by(6)
      end
      it 'creates recipe step ingredients' do
        expect { importer.import }.to change(RecipeStepIngredient, :count).by(20)
      end
    end

    context 'when an invalid recipe is passed' do
      it 'raises an error' do
        recipe_hash = {}
        importer = RecipeImporter::Importer.new(recipe_hash)
        expect { importer.import }.to raise_error(StandardError)
      end
    end
  end
end