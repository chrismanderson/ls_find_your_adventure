class AdventuresController < ApplicationController
  include AdventureMap

  def index
    @map = generate_gmaps
    @gmap_options = AdventureMap.create_map @map
  end

  private

  def generate_gmaps
    Adventure.all.to_gmaps4rails do |adventure, marker|
      marker.infowindow AdventureMap.info to_meta(adventure, "infowindow")
      marker.title   "#{adventure.title}"
      marker.picture AdventureMap.marker_picture_options adventure.sold_out
      marker.sidebar to_meta(adventure, "sidebar")
      marker.json adventure.to_gmaps_json
    end
  end

  def to_meta(adventure, type)
    render_to_string :partial => "/adventures/#{type}",
                     :locals => { :adventure => adventure}
  end
end
