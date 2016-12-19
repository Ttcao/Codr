class AddBooleanToCompaniesDevelopersTable < ActiveRecord::Migration[5.0]
  def change
    change_table :companies_developers do |t|
      t.boolean :accepted
    end
  end
end
