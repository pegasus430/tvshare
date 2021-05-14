class Network < ApplicationRecord
  has_and_belongs_to_many :shows
  scope :active, -> { Network.where.not(display_name: nil).where.not(station_id: nil) }
end
