class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :post, null: false, index: true, foreign_key: true
      t.timestamps
    end
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
