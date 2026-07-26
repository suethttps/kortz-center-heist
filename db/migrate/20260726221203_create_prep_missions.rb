# frozen_string_literal: true

# Prep missions do Planning Board (obrigatórias e opcionais).
class CreatePrepMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :prep_missions do |t|
      t.string :name
      t.string :category      # scope, equipment, infiltration, weapons, getaway, optional
      t.boolean :mandatory    # true = precisa pra lançar a finale
      t.text :unlock_hint     # Como liberar no Scope Out
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
