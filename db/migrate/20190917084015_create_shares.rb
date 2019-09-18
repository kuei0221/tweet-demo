class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.integer :shared_id
      t.integer :sharing_id

      t.timestamps
    end

    add_index :shares, :shared_id
    add_index :shares, :sharing_id
  end
end
