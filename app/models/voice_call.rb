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

  Reasons = OpenStruct.new({
    call_started: "call_started",
    conference_ended: "conference_ended",
    conference_handled: "conference_handled",
    conference_over: "conference_over",
    provider_prompt: "provider_prompt",
    provider_selected: "provider_selected",
    provider_already_joined: "provider_already_joined",
    joined: "joined"
  })

  enum direction: Directions.to_h
  enum status: Statuses.to_h
  enum reason: Reasons.to_h

  belongs_to :conference, optional: true

  phony_normalize :number, default_country_code: "US"
  validates :number, phony_plausible: true, presence: true

  validates :direction, presence: true
  validates :status, presence: true
  validates :reason, presence: true
end
