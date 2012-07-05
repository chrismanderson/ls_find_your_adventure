require 'spec_helper'

include Geocoding

describe Adventure do

  before do
    Geocoding.stub_geocoding
  end

  before(:each) do
    5.times do
      FactoryGirl.create(:adventure)
      puts Adventure.last.market.city
    end
  end

  

  let!(:site_domain) { "http://example.com" }
  it "loads the page" do 
    visit "http://example.com"
    page.should have_content "City"
    page.should have_content Adventure.first.title
    page.should have_content Adventure.first.price
    page.should have_content Adventure.first.market.city
  end
end