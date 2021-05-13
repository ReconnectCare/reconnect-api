class CreateConferenceNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :conference_numbers, id: :uuid do |t|
      t.string :number, null: false

      t.timestamps
    end
  end
end
