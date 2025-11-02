class CreateAbstinenceSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :abstinence_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.timestamps
    end
    add_index :abstinence_sessions, [:user_id, :started_at]
  end
end
