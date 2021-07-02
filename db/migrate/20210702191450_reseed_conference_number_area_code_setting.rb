class ReseedConferenceNumberAreaCodeSetting < ActiveRecord::Migration[6.1]
  def up
    load "db/seeds.rb"
  end

  def down
  end
end
