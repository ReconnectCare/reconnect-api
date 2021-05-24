class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.string :value, null: false
      t.string :value_type, null: false

      t.timestamps
    end
  end
end
