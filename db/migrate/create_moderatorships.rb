class CreateModeratorships < ActiveRecord::Migration[7.0]
  def change
    create_table :moderatorships do |t|
      t.integer :modrepe, default: 0
      t.integer :activity_time_start
      t.integer :activity_time_end
    end
  end
end