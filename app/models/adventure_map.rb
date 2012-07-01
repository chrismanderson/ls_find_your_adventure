module AdventureMap
  def self.map_options
    {"auto_zoom" => true,
      "auto_adjust" => true,
      "mapTypeControl" => true,
      "detect_location" => true,
      "center_on_user" => true}
  end

  def self.marker_options
    { 
      list_container: 'sidebar_adventure_list'
    }
  end
end