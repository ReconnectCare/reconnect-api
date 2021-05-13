class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :external_id
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :gender, null: false
      t.string :office_phone
      t.string :cell_phone, null: false
      t.string :email, null: false
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
