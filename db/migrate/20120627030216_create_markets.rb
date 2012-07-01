class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :city
      t.float       :latitude
      t.float       :longitude
      t.boolean     :gmaps
      t.timestamps
    end
  end
end
