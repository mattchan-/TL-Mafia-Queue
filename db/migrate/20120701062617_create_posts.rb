class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :owner_id
      t.integer :topic_id

      t.timestamps
    end
    add_index :posts, [:topic_id, :owner_id, :created_at]
    add_index :posts, [:topic_id, :created_at]
  end
end
