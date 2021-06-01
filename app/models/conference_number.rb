class ConferenceNumber < ApplicationRecord
  has_many :conferences

  phony_normalize :number, default_country_code: "US"
  validates :number, phony_plausible: true, presence: true

  scope :available_numbers, -> {
    where(
      "id NOT IN (:active_conferences)",
      active_conferences: Conference.active_conferences.select(:conference_number_id)
    )
  }

  def to_s
    number.phony_formatted
  end
end
