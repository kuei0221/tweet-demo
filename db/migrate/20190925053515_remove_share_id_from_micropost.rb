class RemoveShareIdFromMicropost < ActiveRecord::Migration[5.2]
  def change
    remove_column :microposts, :share_id
  end
end
