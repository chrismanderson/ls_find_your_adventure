class Market < ActiveRecord::Base
  has_many :adventures
  attr_accessible :city
end
