class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean, default: false
    add_column :users, :host_privileges, :boolean, default: false
  end
end
