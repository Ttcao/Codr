class CreateCompaniesDevelopers < ActiveRecord::Migration[5.0]
  def change
    create_table :companies_developers do |t|
      t.integer :company_id
      t.integer :developer_id
    end
  end
end
