class CreateActionPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :action_plans do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :post, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
