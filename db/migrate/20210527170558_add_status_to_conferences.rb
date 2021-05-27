class AddStatusToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :status, :string, null: false, default: "ready"
    add_index :conferences, :status
  end
end
