require 'spec_helper'

describe AdventuresHelper do
  class DummyClass
  end

  before(:all) do
    @dummy = DummyClass.new
    @dummy.extend AdventuresHelper
  end

  describe "#to_minutes" do
    it "returns a number multipled by 60" do
      @dummy.to_minutes(5).should == 300
    end

    it "returns an integer" do
      @dummy.to_minutes(5).should be_an Integer
    end
  end
end