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
      list_container: 'sidebar_adventure_list',
      raw: '{ animation: google.maps.Animation.DROP }'
    }
  end

  def self.marker_picture_options sold_out
    {
      :picture => "https://dl.dropbox.com/u/575197/default_#{sold_out}.png",
      :width => 32,
      :height => 37
    }
  end

  def self.info content
    "<div style='width: 350px'>#{content}</div>"
  end

  def self.create_map map
    {
      "map_options" => map_options,
      "markers" => { "data" => map,
                     "options" => marker_options
            }
    }
  end
end