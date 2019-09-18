class AddSharesCountToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :shares_count, :integer, default: 0
  end
end
