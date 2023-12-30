class CreateGrocerySections < ActiveRecord::Migration[7.0]
  def change
    create_table :grocery_sections do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        GrocerySection.create_translation_table! name: {type: :string, null: false}, description: {type: :text, null: false}
      end

      dir.down do
        GrocerySection.drop_translation_table!
      end
    end
  end
end
