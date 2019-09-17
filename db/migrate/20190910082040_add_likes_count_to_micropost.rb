class AddLikesCountToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :likes_count, :integer, default: 0
  end
end
