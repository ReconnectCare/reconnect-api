class AddSidToConferenceNumbers < ActiveRecord::Migration[6.1]
  def change
    add_column :conference_numbers, :sid, :string
  end
end
