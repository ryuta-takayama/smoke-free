class ChangeAbstinenceSessionsStartedAtAllowNull < ActiveRecord::Migration[7.1]
  def Change
    change_column_null :abstinence_sessions, :started_at, true
  end
end
