# frozen_string_literal: true

# Cria a tabela de alvos (primary + secondary) do heist.
# Migrations são o "histórico versionado" do banco — nunca edite uma
# migration já aplicada em produção; crie outra pra alterar.
class CreateTargets < ActiveRecord::Migration[8.1]
  def change
    create_table :targets do |t|
      t.string :name                       # Nome da pintura / item
      t.string :kind                       # "primary" ou "secondary"
      t.string :location                   # Onde fica no museu
      t.integer :first_weekly_payout       # Payout da 1ª venda pós-reset
      t.integer :repeat_payout             # Buyer fatigue (runs extras)
      t.integer :bag_weight                # % estimado da bolsa (didático)
      t.text :notes                        # Observações pra crew
      t.integer :position                  # Ordem no quadro

      t.timestamps # created_at / updated_at automáticos
    end
  end
end
