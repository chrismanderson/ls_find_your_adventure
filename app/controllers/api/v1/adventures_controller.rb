class Api::V1::AdventuresController < ApplicationController
  respond_to :html, :json, :xml

  def index
    @adventures = Adventure.all
    render :json => @adventures
  end
end