require "rubygems"
require "bundler/setup"
require "test/unit"
require "mocha/test_unit"

# Mock Hiera helper methods.
class Hiera
  def self.warn(msg); end
  def self.debug(msg); end

  Config = {}
end
