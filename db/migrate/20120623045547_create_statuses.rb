class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :statuses, :name
  end
end
