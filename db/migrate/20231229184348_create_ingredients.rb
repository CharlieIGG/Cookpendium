class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Ingredient.create_translation_table! name: {type: :string, null: false}
      end

      dir.down do
        Ingredient.drop_translation_table!
      end
    end
  end
end
