class Market < ActiveRecord::Base
  has_many :adventures
  acts_as_gmappable
  attr_accessible :city

  def gmaps4rails_address
    "#{self.city}"
  end
end
