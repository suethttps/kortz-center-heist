# frozen_string_literal: true

# =============================================================================
# Migration: índices
# -----------------------------------------------------------------------------
# Índices aceleram WHERE/ORDER em colunas que consultamos sempre
# (kind nos targets, mandatory nas preps, position pra ordenação do board).
#
# Rode com: bin/rails db:migrate
# =============================================================================
class AddIndexesToHeistTables < ActiveRecord::Migration[8.1]
  def change
    add_index :targets, :kind
    add_index :targets, :position
    add_index :prep_missions, :mandatory
    add_index :prep_missions, :category
    add_index :entry_points, :position
  end
end
