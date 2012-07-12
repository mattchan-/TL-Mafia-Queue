class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_cap
      t.integer :host_id
      t.integer :topic_id
      t.boolean :mini
      t.boolean :invite
      t.string  :category
      t.string :status, default: "Signups Open"

    t.timestamps
    end

    add_index :games, :player_cap
    add_index :games, :host_id
    add_index :games, :topic_id
    add_index :games, :mini
    add_index :games, :invite
    add_index :games, :category
    add_index :games, :status
  end
end
