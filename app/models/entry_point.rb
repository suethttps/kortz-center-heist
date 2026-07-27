# frozen_string_literal: true

# =============================================================================
# EntryPoint
# -----------------------------------------------------------------------------
# Pontos de entrada do museu Kortz Center.
#
# No jogo você fotografa 4 entradas no Scope Out:
#   1. Staff Entrance  (térreo)
#   2. Skylight        (telhado)
#   3. Loading Bay     (doca / CCTV)
#   4. Sewer           (bueiro no labirinto de sebes)
#
# O prep de "Infiltration Gear" escolhe QUAL entrada você usa na finale.
# Cada gear mapeia 1:1 para um entry point — por isso guardamos gear_option.
# =============================================================================
class EntryPoint < ApplicationRecord
  validates :name, presence: true
  validates :gear_option, presence: true

  scope :ordered, -> { order(:position, :name) }

  # Texto curto para o "polaroid" no quadro
  def board_caption
    "#{name} → #{gear_option}"
  end

  # Tem vídeo/guia externo (ex.: YouTube da Skylight)
  def guide?
    guide_url.present?
  end
end
