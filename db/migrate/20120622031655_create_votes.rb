class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :game_id
      t.integer :user_id

      t.timestamps
    end

    add_index :votes, :game_id
    add_index :votes, :user_id
  end
end
