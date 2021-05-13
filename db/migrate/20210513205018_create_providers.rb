class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers, id: :uuid do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :phy_code, null: false
      t.string :cell_phone, null: false

      t.timestamps
    end
  end
end
