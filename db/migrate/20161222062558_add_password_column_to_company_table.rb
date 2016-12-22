class AddPasswordColumnToCompanyTable < ActiveRecord::Migration[5.0]
  def change
    change_table :companies do |t|
      t.text :password_digest
    end
  end
end
