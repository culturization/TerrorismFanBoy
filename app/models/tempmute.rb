class Tempmute < ActiveRecord::Base
  belongs_to :member
  
  validates :reset, presence: true
end