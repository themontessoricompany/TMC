class CreateBreakoutSessionLocations < ActiveRecord::Migration
  def change
    create_table :breakout_session_locations do |t|
      t.string :name
      t.references :conference, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
