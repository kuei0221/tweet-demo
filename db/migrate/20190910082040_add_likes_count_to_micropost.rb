class AddLikesCountToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :likes_count, :integer
  end
end
