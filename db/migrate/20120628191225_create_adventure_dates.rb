class CreateAdventureDates < ActiveRecord::Migration
  def change
    create_table :adventure_dates do |t|
      t.datetime        :date
      t.timestamps
    end
  end
end
