# frozen_string_literal: true

# =============================================================================
# Target
# -----------------------------------------------------------------------------
# Representa um alvo do heist (primário ou secundário).
#
# PRIMARY — matriz de payout (comunidade / GTA Boom):
#   Easy / Hard  ×  First weekly (No alarm / Alarm)  ×  Repeat (No alarm / Alarm)
#
# SECONDARY — usa first_weekly_payout / repeat_payout (mesmo valor nas duas).
#
# Imagens (quando tiver): app/assets/images/targets/<slug>.png
# =============================================================================
class Target < ApplicationRecord
  KINDS = %w[primary secondary].freeze

  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :first_weekly_payout, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :repeat_payout, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :primary,   -> { where(kind: "primary").order(:position) }
  scope :secondary, -> { where(kind: "secondary").order(:position) }
  scope :ordered,   -> { order(:position, :name) }

  def primary?
    kind == "primary"
  end

  def secondary?
    kind == "secondary"
  end

  # -------------------------------------------------------------------------
  # Payout helpers — primary usa a matriz; secondary cai nos campos antigos
  # -------------------------------------------------------------------------

  # Valor "hero" padrão: Easy · 1ª da semana · sem alarme
  def display_first_weekly
    easy_first_no_alarm || first_weekly_payout || 0
  end

  def display_repeat
    easy_repeat || repeat_payout || first_weekly_payout || 0
  end

  def weekly_bonus_difference
    display_first_weekly.to_i - display_repeat.to_i
  end

  # Retorna o valor conforme dificuldade + contexto (first/repeat + alarm)
  # difficulty: "easy" | "hard"
  # run: "first" | "repeat"
  # alarm: true/false
  def payout_for(difficulty: "easy", run: "first", alarm: false)
    key = [
      difficulty.to_s,
      (run.to_s == "first" ? "first" : "repeat"),
      (alarm ? "alarm" : "no_alarm")
    ].join("_")

    mapping = {
      "easy_first_no_alarm"  => easy_first_no_alarm,
      "easy_first_alarm"     => easy_first_alarm,
      "easy_repeat_no_alarm" => easy_repeat,
      "easy_repeat_alarm"    => easy_repeat_alarm,
      "hard_first_no_alarm"  => hard_first_no_alarm,
      "hard_first_alarm"     => hard_first_alarm,
      "hard_repeat_no_alarm" => hard_repeat,
      "hard_repeat_alarm"    => hard_repeat_alarm
    }

    mapping[key] || first_weekly_payout
  end

  # Hash completo pra a view/JS montar a tabela
  def payout_matrix
    {
      easy: {
        repeat: easy_repeat,
        first_no_alarm: easy_first_no_alarm,
        first_alarm: easy_first_alarm,
        repeat_alarm: easy_repeat_alarm
      },
      hard: {
        repeat: hard_repeat,
        first_no_alarm: hard_first_no_alarm,
        first_alarm: hard_first_alarm,
        repeat_alarm: hard_repeat_alarm
      }
    }
  end

  # -------------------------------------------------------------------------
  # Imagem
  # -------------------------------------------------------------------------
  def image_slug
    name.to_s
        .unicode_normalize(:nfd)
        .gsub(/\p{M}/, "")
        .downcase
        .gsub(/[^a-z0-9]+/, "-")
        .gsub(/\A-|-\z/, "")
  end

  def image_path
    "targets/#{image_slug}.png"
  end

  def image_available?
    Rails.root.join("app/assets/images", image_path).exist?
  end
end
