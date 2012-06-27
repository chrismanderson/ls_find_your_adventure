class AdventuresController < ApplicationController
  # GET /adventures
  # GET /adventures.json
  def index
    @adventures = Adventure.all
    @markets = Market.all
    @map = @adventures.to_gmaps4rails do |adventure, marker|
      marker.infowindow render_to_string(:partial => "/adventures/infowindow", :locals => { :adventure => adventure})
      marker.title   "#{adventure.title}"
      marker.json({ :market => adventure.market.city })
    end

    @gmap_options = {"map_options" => {"auto_zoom" => true,
     "zoom" => 22,
     "zoomControl" => true,
     "mapTypeControl" => true,
     "detect_location" => true,
     "center_on_user" => true},
                     "markers" => {"data" => @map}}
  end
end
