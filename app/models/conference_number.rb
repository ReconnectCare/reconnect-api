class ConferenceNumber < ApplicationRecord
  has_many :conferences

  scope :first_available, -> {
    first
  }

  def to_s
    number
  end
end
