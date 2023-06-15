class Guild < ActiveRecord::Base
  has_many :members
  has_many :actions
  has_many :modroles, through: :members
  has_many :tempmutes, through: :members
  has_many :tempbans, through: :members
  has_many :temproles, through: :members
  
  validates :guild_id, presence: true
end