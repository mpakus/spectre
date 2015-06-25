class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string :name,        limit: 255
      t.text   :description, limit: 65535
      t.string :location,    limit: 255
      t.date   :start_on
      t.date   :finish_on
      t.integer :duration
      t.integer :state, limit: 1, index: true, default: 0
      t.timestamps null: false
    end
  end
end
