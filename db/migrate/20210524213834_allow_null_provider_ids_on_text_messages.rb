class AllowNullProviderIdsOnTextMessages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :text_messages, :provider_id, true
  end
end
