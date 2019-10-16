class AddNewNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :new, :boolean, default: true
  end
end
