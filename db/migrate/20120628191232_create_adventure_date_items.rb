class CreateAdventureDateItems < ActiveRecord::Migration
  def change
    create_table :adventure_date_items do |t|
      t.integer     :adventure_id
      t.integer     :adventure_date_id
      t.timestamps
    end
  end
end
