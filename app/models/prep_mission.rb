# frozen_string_literal: true

# =============================================================================
# PrepMission
# -----------------------------------------------------------------------------
# Missões de preparação que aparecem no Planning Board do Art Studio.
#
# No Kortz Center Heist existem:
#   - Preps OBRIGATÓRIAS (Scope Out, Access Code, Hacking Device,
#     Infiltration Gear, Unmarked Weapons, Getaway Vehicle)
#   - Preps OPCIONAIS (EMP, Guard Routes, Guard Shipments, Power Drills,
#     Glass Cutter) — desbloqueadas fotografando coisas no Scope Out
#
# Dica de aprendizado Rails: booleans no banco costumam ser true/false;
# o ActiveRecord ainda aceita "t"/"f" no SQLite, mas sempre use true/false
# no Ruby para deixar o código claro.
# =============================================================================
class PrepMission < ApplicationRecord
  # Categorias usadas para agrupar no quadro (como pastas no board)
  CATEGORIES = %w[
    scope
    equipment
    infiltration
    weapons
    getaway
    optional
  ].freeze

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # Preenche mandatory como false se ninguém setar (evita nil chato nas views)
  after_initialize :set_defaults, if: :new_record?

  scope :mandatory, -> { where(mandatory: true).order(:position) }
  scope :optional,  -> { where(mandatory: false).order(:position) }
  scope :ordered,   -> { order(:position, :name) }
  scope :by_category, ->(cat) { where(category: cat).order(:position) }

  # Friendly label for the UI
  def category_label
    {
      "scope"         => "Scope",
      "equipment"     => "Equipment",
      "infiltration"  => "Infiltration",
      "weapons"       => "Weapons",
      "getaway"       => "Getaway",
      "optional"      => "Optional"
    }.fetch(category, category.to_s.titleize)
  end

  private

  # Callback: valores padrão ao criar um novo registro em memória
  def set_defaults
    self.mandatory = false if mandatory.nil?
    self.position ||= 0
  end
end
