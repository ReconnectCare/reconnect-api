require "test_helper"

module AbilityTest
  def assert_can ability, model, *actions
    actions.each do |action|
      assert ability.can?(action, model), "Should be able to #{action} on #{model}"
    end
  end

  def refute_can ability, model, *actions
    actions.each do |action|
      refute ability.can?(action, model), "Should NOT be able to #{action} on #{model}"
    end
  end

  def setup_models roles
    @user = create(:user, roles: roles)
  end

  class Anon < ActiveSupport::TestCase
    setup do
      @ability = Ability.new(nil)
    end

    test "abilities" do
      # assert @ability.can?(:create, Scan)
      # assert_equal 1, Sa.accessible_by(@ability, :index).count
    end
  end

  class User < ActiveSupport::TestCase
    include AbilityTest

    setup do
      @user = create(:user, roles: [:user])
      @ability = Ability.new(@user)
    end

    test "abilities" do
      # assert_equal 1, Sa.accessible_by(@ability, :index).count
    end
  end

  class Admin < ActiveSupport::TestCase
    include AbilityTest

    setup do
      setup_models [:admin]
      @ability = Ability.new(@user)
    end

    test "abilities" do
      assert_can @ability, User, :create, :destroy, :update, :show
    end
  end
end
