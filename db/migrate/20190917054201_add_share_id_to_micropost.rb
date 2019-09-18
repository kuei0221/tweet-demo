class AddShareIdToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :share_id, :integer, default: nil
    add_index :microposts, :share_id
  end
end
