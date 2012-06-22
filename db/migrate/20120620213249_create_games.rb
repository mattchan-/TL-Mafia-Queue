class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.integer :maximum_players
      t.integer :host_id
      t.integer :category_id
      t.boolean :running
      t.integer :signups

    t.timestamps
    end

    add_index :games, :title, unique: true
    add_index :games, :maximum_players
    add_index :games, :host_id
    add_index :games, :category_id
    add_index :games, :running
    add_index :games, :signups
  end
end
