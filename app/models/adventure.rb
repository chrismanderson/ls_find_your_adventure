class Adventure < ActiveRecord::Base
  acts_as_gmappable :process_geocoding => false
  belongs_to :market
  has_many :adventure_date_items
  has_many :adventure_dates, :through => :adventure_date_items

  def gmaps4rails_address
    "#{self.latitude}, #{self.longitude}"
  end

  def self.max_price
    Adventure.maximum('price')
  end

  def self.min_price
    Adventure.minimum('price') 
  end

  def to_gmaps_json
    { :market => market.city, 
      :sold_out => sold_out,
      :price => price,
      :duration => duration,
      :id => id,
      :dates => adventure_dates,
      :name => title
    }
  end

  def image_url_with_size size
    url = self.image_url.split(%r{[^\/]+$}).first
    "#{url}#{size}_q50.jpg"
  end
end
