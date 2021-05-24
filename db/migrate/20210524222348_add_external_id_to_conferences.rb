class AddExternalIdToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :external_id, :string
  end
end
