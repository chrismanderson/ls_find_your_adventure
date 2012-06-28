class AdventureDateItem < ActiveRecord::Base
  belongs_to :adventure_date
  belongs_to :adventure
end
