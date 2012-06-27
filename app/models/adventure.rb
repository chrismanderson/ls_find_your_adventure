class Adventure < ActiveRecord::Base
  acts_as_gmappable :process_geocoding => false
  belongs_to :market
  # attr_accessible :title, :body

  def gmaps4rails_address
    "#{self.latitude}, #{self.longitude}"
  end
end
