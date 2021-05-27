class VoiceCall < ApplicationRecord
  Statuses = OpenStruct.new({
    queued: "queued",
    initiated: "initiated",
    ringing: "ringing",
    in_progress: "in_progress",
    answered: "answered",
    canceled: "canceled",
    failed: "failed",
    busy: "busy",
    no_answer: "no_answer",
    processing: "processing",
    completed: "completed"
  })

  Directions = OpenStruct.new({outbound: "outbound", inbound: "inbound"})

  enum direction: Directions.to_h
  enum status: Statuses.to_h

  belongs_to :conference

  phony_normalize :number, default_country_code: "US"
  validates :number, phony_plausible: true, presence: true

  validates :direction, presence: true
  validates :status, presence: true
end
