class CreateSmokingSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :smoking_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :daily_cigarette_count, null: false
      t.integer :cigarette_price_jpy, null: false
      t.integer :cigarette_per_pack, null:false
      t.datetime :quit_start_datetime, null: false
      t.timestamps
    end
  end
end
