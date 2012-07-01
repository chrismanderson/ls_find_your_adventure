class AdventureDate < ActiveRecord::Base
  attr_accessible :date
  has_many :adventure_date_items

  def self.group_by_month dates
   dates.group_by { |date| date.date.strftime("%B") }
  end
end
