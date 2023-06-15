class Moderatorship < ActiveRecord::Base
  belongs_to :user
  
  validates :modrep, presence: true
end