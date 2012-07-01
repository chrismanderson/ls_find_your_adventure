class Api::V1::MarketsController < ApplicationController
  respond_to :html, :json, :xml

  def index
    @markets = Market.all
    render :json => @markets
  end

  def nearest
    closest_market = Market.near([params[:lat], params[:lng]], params[:radius])
    render :json => closest_market
  end
end