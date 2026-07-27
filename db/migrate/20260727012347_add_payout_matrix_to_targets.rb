# frozen_string_literal: true

# Matriz de payout dos Main Targets:
# Easy/Hard × (1ª semana / Repeat) × (No alarm / Alarm)
class AddPayoutMatrixToTargets < ActiveRecord::Migration[8.1]
  def change
    add_column :targets, :easy_repeat, :integer
    add_column :targets, :easy_first_no_alarm, :integer
    add_column :targets, :easy_first_alarm, :integer
    add_column :targets, :easy_repeat_alarm, :integer
    add_column :targets, :hard_repeat, :integer
    add_column :targets, :hard_first_no_alarm, :integer
    add_column :targets, :hard_first_alarm, :integer
    add_column :targets, :hard_repeat_alarm, :integer
  end
end
