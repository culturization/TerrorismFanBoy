class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.belongs_to :guild
      t.integer :user_id
      t.integer :rep
    end

    add_index :members, [:guild_id, :id], unique: true
  end
end
  