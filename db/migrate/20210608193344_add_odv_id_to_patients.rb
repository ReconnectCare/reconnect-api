class AddOdvIdToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :odv_id, :string
  end
end
