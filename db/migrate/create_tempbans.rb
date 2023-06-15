class CreateTempbans < ActiveRecord::Migration[7.0]
  def change
    create_table :tempbans do |t|
      t.belongs_to :member
      t.datetime :reset
    end
  end
end