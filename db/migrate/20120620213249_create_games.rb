class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.integer :player_cap
      t.integer :host_id
      t.integer :topic_id
      t.integer :status_id, default: 1
      t.boolean :mini
      t.boolean :normal
      t.boolean :invite
      t.boolean :newbie

    t.timestamps
    end

    add_index :games, :title, unique: true
    add_index :games, :player_cap
    add_index :games, :host_id
    add_index :games, :topic_id
    add_index :games, :mini
    add_index :games, :normal
    add_index :games, :invite
    add_index :games, :newbie
    add_index :games, :status_id
  end
end
