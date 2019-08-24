class AddActivatedTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activated_at, :datetime
  end
end
