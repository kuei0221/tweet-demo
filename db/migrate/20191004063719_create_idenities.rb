class CreateIdenities < ActiveRecord::Migration[5.2]
  def change
    create_table :idenities do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
