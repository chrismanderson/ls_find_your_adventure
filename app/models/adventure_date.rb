class AdventureDate < ActiveRecord::Base
  attr_accessible :date
  has_many :adventure_date_items
end
