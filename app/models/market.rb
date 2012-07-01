class Market < ActiveRecord::Base
  has_many :adventures
  acts_as_gmappable
  reverse_geocoded_by :latitude, :longitude
  attr_accessible :city

  def gmaps4rails_address
    "#{self.city}"
  end
end
