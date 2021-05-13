class Conference < ApplicationRecord
  belongs_to :conference_number
  belongs_to :provider, optional: true
  belongs_to :patient

  def to_s
    start_time.to_s
  end
end
