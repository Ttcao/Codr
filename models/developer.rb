class Developer < ActiveRecord::Base
  has_many :companies_developers
  has_many :companies, through: :companies_developers
  has_secure_password
end
