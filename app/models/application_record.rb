# frozen_string_literal: true

# =============================================================================
# ApplicationRecord
# -----------------------------------------------------------------------------
# Classe base de TODOS os models ActiveRecord do app.
# Qualquer método colocado aqui fica disponível em Target, PrepMission, etc.
# =============================================================================
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
