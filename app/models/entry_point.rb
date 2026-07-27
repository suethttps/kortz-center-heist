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

  # ---------------------------------------------------------------------------
  # Imagem ao lado da entrada
  # Pasta: app/assets/images/entry_points/
  # Arquivos esperados:
  #   staff-entrance.png | skylight.png | loading-bay.png | sewer.png
  # ---------------------------------------------------------------------------
  def image_slug
    name.to_s
        .unicode_normalize(:nfd)
        .gsub(/\p{M}/, "")
        .downcase
        .gsub(/[^a-z0-9]+/, "-")
        .gsub(/\A-|-\z/, "")
  end

  def image_path
    "entry_points/#{image_slug}.png"
  end

  def image_available?
    Rails.root.join("app/assets/images", image_path).exist?
  end
end

