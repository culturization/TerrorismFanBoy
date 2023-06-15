class Tempban < ActiveRecord::Base
  belongs_to :member
    
  validates :reset, presence: true
end