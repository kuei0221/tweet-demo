class AddTypeToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :type, :string
  end
end
