class AddCommentsCountsToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :comments_count, :integer, default: 0
  end
end
