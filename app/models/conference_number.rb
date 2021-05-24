class ConferenceNumber < ApplicationRecord
  has_many :conferences

  phony_normalize :number, default_country_code: "US"
  validates :number, phony_plausible: true, presence: true

  scope :first_available, -> {
    first
  }

  def to_s
    number
  end
end
