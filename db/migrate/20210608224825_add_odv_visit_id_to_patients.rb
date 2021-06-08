class AddOdvVisitIdToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :odv_visit_id, :string
  end
end
