require 'spec_helper'

describe Api::V1::MarketsController, :type => :api do
  context "#index" do
    let!(:market) { FactoryGirl.create(:market) }

    def app
      Api::V1::MarketsController.action(:index)
    end

    it 'responds to json' do
      get 'api/v1/markets.json'
      last_response.status.should == 200
    end

    it 'returns a list of markets' do
      get 'api/v1/markets.json'
      parsed_response = JSON.parse last_response.body
      parsed_response.first['city'].should == market.city
    end
  end

  context "#nearest" do
    let!(:market) { FactoryGirl.create(:market, :city => 'Boston') }
    let!(:market_2) { FactoryGirl.create(:market, :latitude => 20.00, :longitude => 20.00) }

    def app
      Api::V1::MarketsController.action(:nearest)
    end

    it 'responds to json' do
      get 'api/v1/markets/nearest?lat=40.0&lng=40.0&radius=400'
      last_response.status.should == 200
    end

    it 'returns the closest city' do
      get 'api/v1/markets/nearest?lat=40.0&lng=-70.0&radius=400'
      parsed_response = JSON.parse last_response.body
      parsed_response.first['city'].should == market.city
    end
  end
end