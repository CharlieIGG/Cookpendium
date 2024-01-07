class AddExtraAttributesToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :servings, :integer
    add_column :recipes, :vegetarian, :boolean
    add_column :recipes, :vegan, :boolean
    add_column :recipes, :cooking_time_minutes, :integer
    add_column :recipes, :prep_time_minutes, :integer

    reversible do |dir|
      dir.up do
        Recipe.add_translation_fields! serving_unit: :string
      end

      dir.down do
        remove_column :recipe_translations, :serving_unit
      end
    end
  end
end
