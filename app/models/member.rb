class Member < ActiveRecord::Base
  belongs_to :guild
  has_one :tempmute
  has_one :tempban
  has_one :moderatorship
  has_many :temproles

  validates :user_id, :rep, presence: true
end