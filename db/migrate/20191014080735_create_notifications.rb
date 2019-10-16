class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true
      t.string :action
      t.string :feeder

      t.timestamps
    end
  end
end
