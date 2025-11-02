class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :target_item, null: false
      t.integer :target_amount_jpy, null: false
      t.datetime :started_on, null: false
      t.datetime :achieved_on, null: false
      t.integer :status, null: false, default: 0, comment:"active=0,achieved=1"
      t.timestamps
    end
  end
end
