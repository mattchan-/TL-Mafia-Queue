class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_cap
      t.integer :host_id
      t.integer :topic_id
      t.boolean :mini
      t.boolean :invite
      t.string  :category
      t.integer :status_id, default: 1

    t.timestamps
    end

    add_index :games, :host_id
    add_index :games, :topic_id
    add_index :games, :status_id
  end
end
