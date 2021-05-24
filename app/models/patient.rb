class Patient < ApplicationRecord
  has_many :conferences

  GENDER = OpenStruct.new({
    male: "male",
    female: "female"
  })

  enum gender: GENDER.to_h

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true

  phony_normalize :cell_phone, default_country_code: "US"
  validates :cell_phone, phony_plausible: true, presence: true

  phony_normalize :office_phone, default_country_code: "US"
  validates :office_phone, phony_plausible: true

  validates :email, format: {with: Devise.email_regexp}, presence: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
