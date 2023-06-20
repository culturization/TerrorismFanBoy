# frozen_string_literal: true

class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.belongs_to :guild
      t.string :event
      t.integer :channel_id
    end
  end
end

class CreateGuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :guilds do |t|
      t.integer :guild_id
    end
  end
end

class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.belongs_to :guild
      t.integer :user_id
      t.integer :rep, default: 0
    end

    add_index :members, %i[guild_id id], unique: true
  end
end

class CreateModeratorships < ActiveRecord::Migration[7.0]
  def change
    create_table :moderatorships do |t|
      t.integer :modrep, default: 0
      t.integer :activity_time_start
      t.integer :activity_time_end
    end
  end
end

class CreateTempbans < ActiveRecord::Migration[7.0]
  def change
    create_table :tempbans do |t|
      t.belongs_to :member
      t.datetime :reset
    end
  end
end

class CreateTempmutes < ActiveRecord::Migration[7.0]
  def change
    create_table :tempmutes do |t|
      t.belongs_to :member
      t.datetime :reset
    end
  end
end

class CreateTemproles < ActiveRecord::Migration[7.0]
  def change
    create_table :temproles do |t|
      t.belongs_to :member
      t.integer :role_id
      t.datetime :reset
    end
  end
end
