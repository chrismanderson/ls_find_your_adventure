require 'spec_helper'

describe Adventure do
  let!(:adventure) { FactoryGirl.create(:adventure) }

  describe "#to_gmaps_json" do
    it "produces a hash" do
      adventure.to_gmaps_json.should be_a Hash
    end

    it "produces a hash with the correct values" do
      test_hash = adventure.to_gmaps_json
      test_hash[:market].should == adventure.market.city
      test_hash[:sold_out].should == adventure.sold_out
      test_hash[:price].should == adventure.price
      test_hash[:name].should == adventure.title
    end
  end

  describe "#image_url_with_size" do
    it "adjusts the image_url to the correct size" do
      test_url = adventure.image_url_with_size 500
      test_url.should == "http://a2.ak.lscdn.net/imgs/60702096-712b-4c13-8f98-87cf0fc51873/500_q50.jpg"
    end
  end

  describe "min/max prices" do
    let!(:adventure2) { FactoryGirl.create(:adventure, :price => 20) }
    let!(:adventure3) { FactoryGirl.create(:adventure, :price => 40) }
    describe ".max_price" do
      it "returns the highest price amoung adventures" do
        Adventure.max_price.should == adventure3.price
      end
    end

    describe ".min_price" do
      it "returns the lowest price amoung adventures" do
        Adventure.min_price.should == adventure.price
      end
    end
  end

  describe "gmaps4rails_address" do
    it "returns the lat and longitude for the adventure" do
      adventure.gmaps4rails_address.should be_a String
      adventure.gmaps4rails_address.should == "#{adventure.latitude}, #{adventure.longitude}"
    end
  end
end