class AddReasonToVoiceCalls < ActiveRecord::Migration[6.1]
  def change
    add_column :voice_calls, :reason, :string, null: false, default: "call_started"
  end
end
