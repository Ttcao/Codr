class Company < ActiveRecord::Base
  has_many :companies_developers
  has_many :developers, through: :companies_developers
  has_secure_password
end
