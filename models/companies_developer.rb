class CompaniesDeveloper < ActiveRecord::Base
  belongs_to :company
  belongs_to :developer
end
