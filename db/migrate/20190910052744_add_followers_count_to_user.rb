class AddFollowersCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :followers_count, :integer
  end
end
