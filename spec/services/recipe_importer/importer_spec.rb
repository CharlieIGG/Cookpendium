require 'rails_helper'

RSpec.describe RecipeImporter::Importer, type: :service do # rubocop:disable Metrics/BlockLength
  describe '#import' do # rubocop:disable Metrics/BlockLength
    context 'when a valid recipe is passed' do # rubocop:disable Metrics/BlockLength
      recipe_hash = YAML.load_file('spec/fixtures/recipe_hash.yaml')
      it 'creates a recipe' do
        expect { RecipeImporter::Importer.call(recipe_hash) }.to change(Recipe, :count).by(1)

        recipe = Recipe.last
        expect(recipe.cooking_time_minutes).to eq(15)
        expect(recipe.prep_time_minutes).to eq(10)
        expect(recipe.serving_unit).to eq('servings')
        expect(recipe.servings).to eq(4)
        expect(recipe.vegan).to eq(true)
        expect(recipe.vegetarian).to eq(true)
      end
      it 'creates ingredients' do
        expect { RecipeImporter::Importer.call(recipe_hash) }.to change(Ingredient, :count).by(9)
      end
      it 'creates recipe ingredients' do
        expect { RecipeImporter::Importer.call(recipe_hash) }.to change(RecipeIngredient, :count).by(9)
      end
      it 'creates recipe steps' do
        expect { RecipeImporter::Importer.call(recipe_hash) }.to change(RecipeStep, :count).by(6)
      end
      it 'creates recipe step ingredients' do
        expect { RecipeImporter::Importer.call(recipe_hash) }.to change(RecipeStepIngredient, :count).by(20)
      end

      it 'safely ingores imaginary attributes not in the model' do
        hash_with_extra_attributes = recipe_hash.merge('extra_attribute' => 'some value')
        expect { RecipeImporter::Importer.call(hash_with_extra_attributes) }.to change(Recipe, :count).by(1)
      end
    end

    context 'when an invalid recipe is passed' do
      it 'raises an error' do
        recipe_hash = {}
        expect do
          RecipeImporter::Importer.call(recipe_hash)
        end.to raise_error(RecipeImporter::Importer::DataStructureError)
      end
    end
  end
end
