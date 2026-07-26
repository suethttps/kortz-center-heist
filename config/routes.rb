# frozen_string_literal: true

# =============================================================================
# Rotas da aplicação
# -----------------------------------------------------------------------------
# O Router é o "porteiro": ele olha a URL e decide qual controller/action rodar.
#
# root "planning_board#index"  significa:
#   GET /  →  PlanningBoardController#index
# =============================================================================
Rails.application.routes.draw do
  # Health check padrão do Rails 8 (útil pra deploy / Docker)
  get "up" => "rails/health#show", as: :rails_health_check

  # Página principal = o quadro de planejamento do heist
  root "planning_board#index"

  # Alias amigável caso alguém queira /board
  get "board", to: "planning_board#index", as: :planning_board
end
