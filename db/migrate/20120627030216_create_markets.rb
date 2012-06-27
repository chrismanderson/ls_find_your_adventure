class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :city

      t.timestamps
    end
  end
end
