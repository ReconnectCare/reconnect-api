class AddReasonToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :reason, :string
  end
end
