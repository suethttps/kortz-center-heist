# frozen_string_literal: true

# =============================================================================
# Target
# -----------------------------------------------------------------------------
# Representa um alvo do heist (primário ou secundário).
#
# Em GTA Online, o "Primary Target" é a pintura obrigatória do cofre.
# Os "Secondary Targets" são obras extras que cabem na bolsa — e a bolsa
# tem espaço limitado, então nem tudo que aparece no quadro entra no bolso.
#
# Dados baseados em guias da comunidade (Beebom, GTA Boom, GameRant, Reddit)
# após o lançamento do Kortz Center Heist (jul/2026). Valores podem mudar
# com patches da Rockstar!
# =============================================================================
class Target < ApplicationRecord
  # Tipos válidos: primary = alvo principal | secondary = loot extra
  KINDS = %w[primary secondary].freeze

  # Validações — Rails rejeita o registro se algo estiver errado
  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :first_weekly_payout, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :repeat_payout, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Escopos (scopes) = atalhos para consultas frequentes
  # Exemplo: Target.primary.first  →  pega o main target
  scope :primary,   -> { where(kind: "primary").order(:position) }
  scope :secondary, -> { where(kind: "secondary").order(:position) }
  scope :ordered,   -> { order(:position, :name) }

  # Retorna true se for o alvo principal da semana
  def primary?
    kind == "primary"
  end

  # Retorna true se for loot secundário (pinturas, joias, etc.)
  def secondary?
    kind == "secondary"
  end

  # Calcula a diferença entre a 1ª run da semana e as seguintes.
  # Essa "buyer fatigue" é o motivo de só valer a pena rodar 1x por semana.
  def weekly_bonus_difference
    return 0 if first_weekly_payout.blank? || repeat_payout.blank?

    first_weekly_payout - repeat_payout
  end

  # Formata o valor da primeira venda semanal (o payout "gordo")
  def display_first_weekly
    first_weekly_payout || 0
  end

  # Formata o valor das runs repetidas (buyer fatigue)
  def display_repeat
    repeat_payout || first_weekly_payout || 0
  end
end
