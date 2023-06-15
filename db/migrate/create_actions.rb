class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.belongs_to :guild
      t.string :event
      t.integer :channel_id
    end
  end
end