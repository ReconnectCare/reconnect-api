require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "a string" do
    setting = Setting.new(name: :test, value: "my string", value_type: Setting::VALUE_TYPES.string)
    assert setting.save

    assert_equal "my string", Setting.get(:test)
  end

  test "an integer" do
    setting = Setting.new(name: :test, value: 33, value_type: Setting::VALUE_TYPES.integer)
    assert setting.save

    assert_equal 33, Setting.get(:test)
  end

  test "a boolean" do
    setting = Setting.new(name: :test, value: true, value_type: Setting::VALUE_TYPES.boolean)
    assert setting.save

    assert_equal true, Setting.get(:test)

    setting = Setting.new(name: :test2, value: false, value_type: Setting::VALUE_TYPES.boolean)
    assert setting.save

    assert_equal false, Setting.get(:test2)
  end

  test "a default" do
    assert_equal "my string", Setting.get(:test, "my string")
  end

  test "render" do
    out = Setting.render("some <%= myValue %> here", {myValue: "bad case"})

    assert_equal "some bad case here", out
  end
end
