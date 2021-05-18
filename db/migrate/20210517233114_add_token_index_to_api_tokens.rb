class AddTokenIndexToApiTokens < ActiveRecord::Migration[6.1]
  def change
    add_index :api_tokens, :token
  end
end
