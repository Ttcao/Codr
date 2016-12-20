class AddUsernamePasswordToDevelopersTable < ActiveRecord::Migration[5.0]
  def change
    change_table :developers do |t|
      t.string :username
      t.text :password_digest
    end
    change_table :companies_developers do |t|

      t.timestamps
    end
  end
end
