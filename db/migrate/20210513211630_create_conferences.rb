class CreateConferences < ActiveRecord::Migration[6.1]
  def change
    create_table :conferences, id: :uuid do |t|
      t.string :sid
      t.datetime :start_time
      t.datetime :end_time
      t.references :conference_number, null: false, foreign_key: true, type: :uuid
      t.references :patient, null: false, foreign_key: true, type: :uuid
      t.references :provider, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
