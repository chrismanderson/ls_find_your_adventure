require 'spec_helper'

include Geocoding

describe Market do
  let(:market) { FactoryGirl.create(:market) }

  before do
    Geocoding.stub_geocoding
  end

  context "creation" do
    it "requires a city" do
      invalid_market = Market.new
      invalid_market.should_not be_valid
    end

    it "saves with a city" do
      market = Market.new(city: "Washington")
      market.should be_valid
    end
  end

  context "geocoding" do
    it "should be geocoded" do
      market.should have_same_position_as TOULON
    end
  end

  describe "#gmaps4rails_address" do
    it "returns the city" do
      market.gmaps4rails_address.should == market.city
    end
  end
end
