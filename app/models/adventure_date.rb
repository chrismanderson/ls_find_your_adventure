class AdventureDate < ActiveRecord::Base
  has_many :adventure_date_items
end
