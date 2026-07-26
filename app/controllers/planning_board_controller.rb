# frozen_string_literal: true

# =============================================================================
# PlanningBoardController
# -----------------------------------------------------------------------------
# Controller "da home" do app — monta o quadro de planejamento.
#
# Fluxo Rails (MVC) em uma frase:
#   Request → Router → Controller → Models (dados) → View (HTML) → Response
#
# Aqui a action #index busca tudo do banco e manda para a view.
# Nenhuma lógica de negócio pesada fica na view — só apresentação.
# =============================================================================
class PlanningBoardController < ApplicationController
  # GET /
  # Página principal: o Planning Board estilo GTA Online.
  def index
    # Carrega alvos separados — a view usa cada coleção numa seção do quadro
    @primary_targets   = Target.primary
    @secondary_targets = Target.secondary

    # Preps obrigatórias vs opcionais (como no board do Art Studio)
    @mandatory_preps = PrepMission.mandatory
    @optional_preps  = PrepMission.optional

    # Entradas do museu (Staff, Skylight, Loading Bay, Sewer)
    @entry_points = EntryPoint.ordered

    # Números-resumo para o "post-it" de economia no canto do quadro
    @economy = build_economy_summary
  end

  private

  # Monta um hash com os números mais citados pela comunidade.
  # Mantemos isso no controller (e não hardcoded na view) para ficar fácil
  # de ajustar quando a Rockstar der nerf/buff.
  def build_economy_summary
    main = Target.primary.first

    {
      # Taxa de setup: gratuita na 1ª run da semana, depois $100k
      setup_fee_first: 0,
      setup_fee_repeat: 100_000,

      # Bônus extras reportados pela comunidade
      buyer_request_normal: 50_000,
      buyer_request_hard: 100_000,
      elite_challenge_normal: 50_000,
      elite_challenge_hard: 100_000,

      # Estimativas realistas de take solo (1ª run)
      solo_first_min: 2_000_000,
      solo_first_max: 2_250_000,

      # Take máximo teórico com crew de 4 (todo o museu)
      crew_max_reported: 7_143_000,

      # Reset semanal = toda quinta (mesmo ciclo dos outros heists)
      weekly_reset: "Quinta-feira",

      # Main target atual (se o seed rodou)
      main_target_name: main&.name,
      main_first: main&.first_weekly_payout,
      main_repeat: main&.repeat_payout
    }
  end
end
