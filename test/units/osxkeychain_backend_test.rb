require File.expand_path("../../test_helper", __FILE__)

require "hiera/backend/osxkeychain_backend"

class OsxKeychainBackendTest < Test::Unit::TestCase
  def setup
    Hiera::Config[:osx_keychain] = {
      :service => "service"
    }
    @backend = Hiera::Backend::Osxkeychain_backend.new
    @keychain = mock()
    @backend.stubs(:keychain).returns(@keychain)
  end

  def test_missing_key
    @keychain.expects(:lookup).with(:account => "key").returns(nil)
    result = @backend.lookup("key", {}, nil, :priority)
    assert_nil result
  end

  def test_missing_key_with_five_arguments
    @keychain.expects(:lookup).with(:account => "key").returns(nil)
    assert_throw :no_such_key do
      @backend.lookup("key", {}, nil, :priority, nil)
    end
  end

  def test_existing_key
    @keychain.expects(:lookup).with(:account => "key").returns("value")
    result = @backend.lookup("key", {}, nil, :priority)
    assert_equal "value", result
  end

  def test_existing_key_with_array
    @keychain.expects(:lookup).with(:account => "key").returns("value")
    result = @backend.lookup("key", {}, nil, :array)
    assert_equal ["value"], result
  end
end
