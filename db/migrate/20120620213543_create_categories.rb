class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :tag

    end

    add_index :categories, :name
  end
end
