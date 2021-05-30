class Conference < ApplicationRecord
  belongs_to :conference_number
  belongs_to :provider, optional: true
  belongs_to :patient

  has_many :voice_calls
  has_many :text_messages

  has_one_attached :recording

  Statuses = OpenStruct.new({
    ready: "ready", # Created, but waiting for provider and patient
    waiting: "waiting",
    in_progress: "in_progress", # Provider & patient joined
    completed: "completed"
  })

  enum status: Statuses.to_h

  scope :in_progress_to, ->(number) {
    joins(:conference_number).where(status: [:ready, :waiting]).where("conference_numbers.number = ?", number).where("conferences.end_time IS NULL")
  }

  scope :active_conferences, -> {
    where.not(status: "completed")
  }

  def to_s
    start_time.to_s
  end
end
