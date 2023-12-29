class CreateRecipeSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_steps do |t|
      t.integer :step_number

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        RecipeStep.create_translation_table! instruction: :text
      end

      dir.down do
        RecipeStep.drop_translation_table!
      end
    end
  end
end
