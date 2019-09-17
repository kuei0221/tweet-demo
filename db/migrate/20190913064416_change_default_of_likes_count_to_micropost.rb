class ChangeDefaultOfLikesCountToMicropost < ActiveRecord::Migration[5.2]
  def change
    change_column_default :microposts, :likes_count, from: nil, to: 0
  end
end
