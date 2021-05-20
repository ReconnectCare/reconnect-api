class CreateTextMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :text_messages, id: :uuid do |t|
      t.string :provider_id, null: false
      t.string :direction, null: false
      t.string :status, null: false
      t.string :body
      t.string :error_code
      t.string :number, null: false
      t.references :conference, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
