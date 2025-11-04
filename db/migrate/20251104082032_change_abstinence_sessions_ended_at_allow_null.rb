class ChangeAbstinenceSessionsEndedAtAllowNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :abstinence_sessions, :ended_at, true
  end
end
