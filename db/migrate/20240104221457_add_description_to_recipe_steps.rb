class AddDescriptionToRecipeSteps < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        RecipeStep.add_translation_fields! description: { type: :text, null: false }
      end

      dir.down do
        remove_column :recipe_step_translations, :description
      end
    end
  end
end
