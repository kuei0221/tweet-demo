class RenameIdenityToIdentity < ActiveRecord::Migration[5.2]
  def change
    rename_table :idenities, :identities
  end
end
