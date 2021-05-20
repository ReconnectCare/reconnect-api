class TextMessage < ApplicationRecord
  Statuses = OpenStruct.new({
    ready: "ready",
    accepted: "accepted",
    queued: "queued",
    sending: "sending",
    sent: "sent",
    failed: "failed",
    delivered: "delivered",
    undelivered: "undelivered",
    receiving: "receiving",
    received: "received",
    read: "read"
  })
  Directions = OpenStruct.new({outbound: "outbound", inbound: "inbound"})

  enum status: Statuses.to_h
  enum direction: Directions.to_h

  belongs_to :conference

  phony_normalize :number, default_country_code: "US"
  validates :number, phony_plausible: true, presence: true

  validates :body, presence: true
  validates :direction, presence: true
  validates :status, presence: true

  def self.site_number
    Rails.application.credentials.dig(:twilio, :voice_number)
  end

  def to_s
    to
  end
end
