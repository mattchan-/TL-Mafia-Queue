class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :owner_id
      t.integer :game_id

      t.timestamps
    end
    add_index :posts, :game_id
    add_index :posts, :owner_id
    add_index :posts, :created_at
  end
end
