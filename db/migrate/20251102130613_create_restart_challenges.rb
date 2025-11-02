class CreateRestartChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :restart_challenges do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :expire_at, null: false
      t.integer :status, null: false, default: 0, comment: "pending=0,success=1,failed=2"
      t.datetime :completed_at, null: true
      t.timestamps
    end
    add_index :restart_challenges, [:user_id, :started_at]
  end
end
