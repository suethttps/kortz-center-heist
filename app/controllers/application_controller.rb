# frozen_string_literal: true

# =============================================================================
# ApplicationController
# -----------------------------------------------------------------------------
# Pai de todos os controllers. Filtros globais (auth, locale, etc.) iriam aqui.
# Por enquanto só as proteções padrão do Rails 8.
# =============================================================================
class ApplicationController < ActionController::Base
  # Bloqueia browsers antigos demais (Rails 8 default)
  allow_browser versions: :modern

  # Invalida cache de HTML se o importmap mudar
  stale_when_importmap_changes
end
