class AdventuresController < ApplicationController
  include AdventureMap

  def index
    @adventures = Adventure.all
    @markets = Market.all
    @map = @adventures.to_gmaps4rails do |adventure, marker|
      marker.infowindow render_to_string(:partial => "/adventures/infowindow", :locals => { :adventure => adventure})
      marker.title   "#{adventure.title}"
      marker.picture({
        :picture => "https://dl.dropbox.com/u/575197/default_#{adventure.sold_out}.png",
        :width => 32,
        :height => 37
      })
      marker.sidebar render_to_string(:partial => "/adventures/sidebar", :locals => { :adventure => adventure})
      marker.json({ :market => adventure.market.city, 
                    :sold_out => adventure.sold_out,
                    :price => adventure.price,
                    :id => adventure.id,
                    :dates => adventure.adventure_dates,
                    :name => adventure.title
                  })
    end

    @gmap_options = {"map_options" => AdventureMap.map_options,
      "markers" => {"data" => @map,
                    "options" => AdventureMap.marker_options}
    }
  end
end
