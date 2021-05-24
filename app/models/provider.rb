class Provider < ApplicationRecord
  has_many :conferences

  validates :external_id, presence: true
  validates :name, presence: true
  validates :phy_code, presence: true

  phony_normalize :cell_phone, default_country_code: "US"
  validates :cell_phone, phony_plausible: true, presence: true

  def to_s
    name
  end
end
