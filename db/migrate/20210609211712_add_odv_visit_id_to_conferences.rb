class AddOdvVisitIdToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :odv_visit_id, :string
  end
end
