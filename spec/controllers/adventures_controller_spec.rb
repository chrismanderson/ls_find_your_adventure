require 'spec_helper'

describe AdventuresController do
  context '#index' do
    let!(:adventure_1) { FactoryGirl.create(:adventure, :sold_out => true ) }
    let!(:adventure_2) { FactoryGirl.create(:adventure) }
    def app
      AdventuresController.action(:index)
    end

    it 'returns 200 on get' do
      get '/adventures' 
      last_response.status.should == 200
    end

    it "creates markers" do
      adventure = mock_model(Adventure)
      Adventure.should_receive(:all).and_return
      get '/adventures'    
    end

    it "creates the map json" do
      AdventureMap.should_receive(:create_map)
      get '/adventures'    
    end
  end

  context '#to_meta' do
    let!(:adventure_1) { FactoryGirl.create(:adventure, :sold_out => true ) }
    let!(:adventure_2) { FactoryGirl.create(:adventure) }

    def app
      AdventuresController.action(:to_meta)
    end

    it 'returns a string' do
      @controller = AdventuresController.new
      @controller.should_receive(:to_meta)
      @controller.instance_eval { to_meta }
    end
  end
end
