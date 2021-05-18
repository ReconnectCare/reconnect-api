class ApiToken < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :token, presence: true

  scope :active, -> { where(deleted_at: nil) }

  scope :deleted, -> { where.not(deleted: nil) }

  def delete!
    update(deleted_at: Time.now)
  end

  def called!
  end

  def make_token
    self.token = JsonToken.encode({user_id: user_id})
    self
  end

  def to_s
    name
  end
end
