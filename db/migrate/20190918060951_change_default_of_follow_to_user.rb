class ChangeDefaultOfFollowToUser < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :followers_count, from:nil, to: 0
    change_column_default :users, :following_count, from:nil, to: 0
  end
end
