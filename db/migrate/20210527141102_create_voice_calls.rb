class CreateVoiceCalls < ActiveRecord::Migration[6.1]
  def change
    create_table :voice_calls, id: :uuid do |t|
      t.string :provider_id, null: false
      t.references :conference, null: false, foreign_key: true, type: :uuid
      t.string :direction, null: false
      t.string :status, null: false
      t.string :number, null: false

      t.timestamps
    end
  end
end
