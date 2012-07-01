require 'spec_helper'

describe AdventureMap do
  class DummyClass
  end

  before(:all) do
    @dummy = DummyClass.new
    @dummy.extend AdventureMap
  end

  describe ".map_options" do
    it "returns a hash of the default map options" do
      AdventureMap.map_options.should be_a Hash
    end
  end

  describe ".marker_options" do
    it "returns a hash of the default marker options" do
      AdventureMap.map_options.should be_a Hash
      AdventureMap.marker_options[:list_container].should == "sidebar_adventure_list"
      AdventureMap.marker_options[:raw].should == '{ animation: google.maps.Animation.DROP }'
    end
  end

  describe ".marker_picture_options" do
    it "provides a url based on the boolean parameter" do
      options = AdventureMap.marker_picture_options true
      options.should be_a Hash
      options[:picture].should == "https://dl.dropbox.com/u/575197/default_true.png"
    end
  end

  describe ".create_map" do
    it "provides map paramters in a hash" do
      AdventureMap.create_map('map').should be_a Hash
    end
  end
end