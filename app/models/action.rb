class Action < ActiveRecord::Base
  belongs_to :guild

  validates :event, :channel_id, presence: true
end