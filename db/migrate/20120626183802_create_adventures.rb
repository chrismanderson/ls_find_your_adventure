class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string      :title
      t.string      :market
      t.string      :address
      t.string      :city
      t.string      :state
      t.decimal     :duration
      t.string      :buy_url
      t.string      :image_url
      t.integer     :zipcode
      t.text        :description
      t.text        :details
      t.integer     :price
      t.float       :latitude
      t.float       :longitude
      t.boolean     :sold_out
      t.integer     :market_id
      t.timestamps
    end
  end
end
