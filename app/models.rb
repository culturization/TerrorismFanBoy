# frozen_string_literal: true

class Action < ActiveRecord::Base
  belongs_to :guild

  validates :event, :channel_id, presence: true
end

class Guild < ActiveRecord::Base
  has_many :members
  has_many :actions
  has_many :modroles, through: :members
  has_many :tempmutes, through: :members
  has_many :tempbans, through: :members
  has_many :temproles, through: :members

  validates :guild_id, presence: true
end

class Member < ActiveRecord::Base
  belongs_to :guild
  has_one :tempmute
  has_one :tempban
  has_one :moderatorship
  has_many :temproles

  validates :user_id, presence: true
  validates :rep, numericality: { only_integer: true }
end

class Moderatorship < ActiveRecord::Base
  belongs_to :user

  validates :modrep, presence: true
end

class Tempban < ActiveRecord::Base
  belongs_to :member

  validates :reset, presence: true
end

class Tempmute < ActiveRecord::Base
  belongs_to :member

  validates :reset, presence: true
end

class Temprole < ActiveRecord::Base
  belongs_to :member

  validates :role_id, :reset, presence: true
end
