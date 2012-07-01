require 'spec_helper'

describe AdventureDate do
  let!(:date_1) { FactoryGirl.create(:adventure_date, :date => Date.new(2012,2,3)) }
  let!(:date_2) { FactoryGirl.create(:adventure_date, :date => Date.new(2012,2,4)) }
  let!(:date_3) { FactoryGirl.create(:adventure_date, :date => Date.new(2012,3,4)) }

  describe ".group_by_month" do
    it "returns dates grouped by month" do
      dates = AdventureDate.group_by_month AdventureDate.all
      dates.length.should == 2
      dates.first.first.should == "February"
      dates.first.last.should == [date_1, date_2]
    end
  end
end