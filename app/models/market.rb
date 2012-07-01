class Market < ActiveRecord::Base
  has_many :adventures
  acts_as_gmappable
  reverse_geocoded_by :latitude, :longitude
  attr_accessible :city

  validates_presence_of :city
  validates_numericality_of :latitude, :longitude

  def gmaps4rails_address
    "#{self.city}"
  end
end
