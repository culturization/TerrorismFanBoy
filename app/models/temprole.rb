class Temprole < ActiveRecord::Base
  belongs_to :member
      
  validates :role_id, :reset, presence: true
end