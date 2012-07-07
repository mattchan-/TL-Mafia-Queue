class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.integer :owner_id

      t.timestamps
    end
    add_index :topics, :updated_at
  end
end
