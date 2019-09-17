class AddPostIdToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :post_id, :integer, default: nil
    add_index :microposts, :post_id
  end
end
