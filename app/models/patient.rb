class Patient < ApplicationRecord
  has_many :conferences

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  # TODO Male / Female struct
  validates :gender, presence: true
  # TODO phony
  validates :cell_phone, presence: true
  # TODO email
  validates :email, presence: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
