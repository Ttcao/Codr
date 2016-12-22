class RemoveUsernameColumnFromUsers < ActiveRecord::Migration[5.0]
  def change
      remove_column :developers, :username
  end
end
