class AddDiscardedAtToConferenceNumbers < ActiveRecord::Migration[6.1]
  def change
    add_column :conference_numbers, :discarded_at, :datetime
    add_index :conference_numbers, :discarded_at
  end
end
