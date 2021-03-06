class Boat < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  mount_uploader :photo, PhotoUploader
  BOAT_TYPE_OPTIONS = ["Power", "Sail"]
  YEAR_OPTIONS = (1930..2018).to_a.reverse!

  belongs_to :user
  has_many :bookings
  validates :make, :model, :capacity, :location, :price, presence: true
  validates :boat_type, inclusion: { in: BOAT_TYPE_OPTIONS , message: "Select one of the list" }
  validates :year, inclusion: { in: YEAR_OPTIONS , message: "Select one of the list" }
  validates :capacity, :price, numericality: { greater_than: 0 }


  include PgSearch
  pg_search_scope :search_by_attributes,
    against: [ :make, :model, :boat_type, :capacity, :year, :location, :price],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
