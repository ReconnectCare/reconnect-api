class AddContestantsToConference < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :contestants, :jsonb, null: false, default: []
  end
end
