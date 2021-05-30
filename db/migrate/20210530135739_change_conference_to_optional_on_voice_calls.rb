class ChangeConferenceToOptionalOnVoiceCalls < ActiveRecord::Migration[6.1]
  def change
    change_column_null :voice_calls, :conference_id, true
  end
end
