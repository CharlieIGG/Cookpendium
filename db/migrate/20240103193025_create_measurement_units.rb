class CreateMeasurementUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :measurement_units do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        MeasurementUnit.create_translation_table! name: { type: :string, null: false }, abbreviation: :string
      end

      dir.down do
        MeasurementUnit.drop_translation_table!
      end
    end
  end
end
