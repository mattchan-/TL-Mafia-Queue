class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :remember_token
      t.boolean :admin, default: :false

      t.timestamps
    end

    add_index :users, :name, unique: true
    add_index :users, :remember_token
  end
end
