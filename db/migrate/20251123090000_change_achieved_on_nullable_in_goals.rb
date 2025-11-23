class ChangeAchievedOnNullableInGoals < ActiveRecord::Migration[7.1]
  def up
    change_column_null :goals, :achieved_on, true
  end

  def down
    # Backfill nils to allow reverting to NOT NULL
    execute <<~SQL
      UPDATE goals
      SET achieved_on = COALESCE(achieved_on, started_on)
    SQL
    change_column_null :goals, :achieved_on, false
  end
end
