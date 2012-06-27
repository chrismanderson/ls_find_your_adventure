class AdventuresController < ApplicationController
  def index
    @adventures = Adventure.all
    @markets = Market.all
    @map = @adventures.to_gmaps4rails do |adventure, marker|
      marker.infowindow render_to_string(:partial => "/adventures/infowindow", :locals => { :adventure => adventure})
      marker.title   "#{adventure.title}"
      marker.sidebar render_to_string(:partial => "/adventures/sidebar", :locals => { :adventure => adventure})
      marker.json({ :market => adventure.market.city, 
                    :price => adventure.price,
                    :name => adventure.title,
                  })
    end

    @gmap_options = {"map_options" => {
      "auto_zoom" => true,
      "auto_adjust" => true,
      "mapTypeControl" => true,
      "detect_location" => true,
      "center_on_user" => true},
      "markers" => {"data" => @map,
                    "options" => { list_container: 'sidebar_adventure_list'}}
    }
  end
end
