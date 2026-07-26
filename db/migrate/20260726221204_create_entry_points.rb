# frozen_string_literal: true

# Pontos de entrada do Kortz Center (Staff / Skylight / Loading Bay / Sewer).
class CreateEntryPoints < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_points do |t|
      t.string :name
      t.string :gear_option  # Infiltration Gear correspondente
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
