class Provider < ApplicationRecord
  validates :external_id, presence: true
  validates :name, presence: true
  validates :phy_code, presence: true
  # TODO: phoney
  validates :cell_phone, presence: true

  def to_s
    name
  end
end
