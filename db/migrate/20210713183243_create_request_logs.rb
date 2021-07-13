class CreateRequestLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :request_logs, id: :uuid do |t|
      t.string :verb
      t.string :uri
      t.jsonb :request_headers
      t.string :request_body
      t.string :status
      t.jsonb :response_headers
      t.string :response_body
      t.jsonb :exception
      t.integer :duration
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
