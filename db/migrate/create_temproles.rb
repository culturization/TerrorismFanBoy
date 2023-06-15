class CreateTemproles < ActiveRecord::Migration[7.0]
  def change
    create_table :temproles do |t|
      t.belongs_to :member
      t.integer :role_id
      t.datetime :reset
    end
  end
end