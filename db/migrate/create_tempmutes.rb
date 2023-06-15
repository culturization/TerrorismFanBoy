class CreateTempmutes < ActiveRecord::Migration[7.0]
  def change
    create_table :tempmutes do |t|
      t.belongs_to :member
      t.datetime :reset
    end
  end
end