# frozen_string_literal: true

# =============================================================================
# ApplicationHelper
# -----------------------------------------------------------------------------
# Helpers são métodos disponíveis em TODAS as views.
# Use para formatação (dinheiro, datas) e pedaços pequenos de HTML.
#
# Regra de ouro: se a lógica crescer demais, vire método de model ou service.
# =============================================================================
module ApplicationHelper
  # Formata um inteiro como dinheiro do GTA Online.
  # Exemplo: 1_925_000  →  "GTA$1,925,000"
  def gta_money(amount)
    return "GTA$—" if amount.nil?

    # delimiter: "," deixa no estilo americano (como o jogo mostra)
    "GTA$#{number_with_delimiter(amount, delimiter: ',')}"
  end

  # Versão curta para caber em cards apertados do board
  # Exemplo: 1_925_000  →  "$1.93M"
  def gta_money_short(amount)
    return "—" if amount.nil?

    if amount >= 1_000_000
      # Duas casas para não perder precisão demais
      "$#{'%.2f' % (amount / 1_000_000.0)}M"
    elsif amount >= 1_000
      "$#{'%.0f' % (amount / 1_000.0)}K"
    else
      "$#{amount}"
    end
  end

  # Classe CSS de "pin" rotacionado — dá vida ao quadro
  def pin_tilt(index)
    # Alterna leves rotações pra não ficar tudo alinhado demais
    tilts = %w[-2deg 1.5deg -1deg 2deg -1.5deg 1deg]
    tilts[index.to_i % tilts.length]
  end
end
