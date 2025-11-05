class DropActionPlans < ActiveRecord::Migration[7.1]
  def change
    drop_table :action_plans do |t|
      # Reversible definition for rollback
      t.references :user, null: false, index: true, foreign_key: true
      t.references :post, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
