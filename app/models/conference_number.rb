class ConferenceNumber < ApplicationRecord
  has_many :conferences

  def to_s
    number
  end
end
