class RemoveVisitIdFromPatients < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :odv_visit_id, :string
  end
end
