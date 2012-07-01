class AdventuresController < ApplicationController
  include AdventureMap

  def index
    @markets = Market.all
    @map = Adventure.all.to_gmaps4rails do |adventure, marker|
      marker.infowindow "<div style='width: 350px'>#{render_meta(adventure, "infowindow")}</div>"
      marker.title   "#{adventure.title}"
      marker.picture AdventureMap.marker_picture_options adventure.sold_out
      marker.sidebar render_meta(adventure, "sidebar")
      marker.json adventure.to_gmaps_json
    end
    @gmap_options = AdventureMap.create_map @map
  end

  private

  def render_meta(adventure, type)
    render_to_string :partial => "/adventures/#{type}", 
                     :locals => { :adventure => adventure}
  end
end
