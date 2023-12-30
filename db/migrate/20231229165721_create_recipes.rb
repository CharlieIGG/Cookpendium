# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Recipe.create_translation_table! title: {type: :string, null: false}, description: {type: :text, null: false}
      end

      dir.down do
        Recipe.drop_translation_table!
      end
    end
  end
end
