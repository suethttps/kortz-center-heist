# frozen_string_literal: true

# =============================================================================
# PlanningBoardHelper
# -----------------------------------------------------------------------------
# Helpers específicos da página do quadro.
# (Por enquanto a formatação de dinheiro vive em ApplicationHelper —
#  este arquivo existe pra quando a UI do board crescer.)
# =============================================================================
module PlanningBoardHelper
  # Conta quantos secondary targets cabem numa bolsa solo "típica"
  # (estimativa didática: soma bag_weight até ~100%).
  def estimated_solo_secondary_capacity(targets)
    used = 0
    picked = []

    # Ordena do mais caro pro mais barato — estratégia óbvia de loot
    targets.sort_by { |t| -(t.first_weekly_payout || 0) }.each do |target|
      weight = target.bag_weight.to_i
      next if weight <= 0
      break if used + weight > 100

      used += weight
      picked << target
    end

    { targets: picked, bag_used: used }
  end
end
