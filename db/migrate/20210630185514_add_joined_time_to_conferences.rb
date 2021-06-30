class AddJoinedTimeToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :joined_time, :datetime
  end
end
