class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.text :text, null: false
      t.string :author, null: false
      t.string :source, null: true, default: "ja"
      t.timestamps
    end
  end
end
