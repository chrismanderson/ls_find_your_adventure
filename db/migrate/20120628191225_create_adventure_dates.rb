class CreateAdventureDates < ActiveRecord::Migration
  def change
    create_table :adventure_dates do |t|
      t.date        :date
      t.timestamps
    end
  end
end
