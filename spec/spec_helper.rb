# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "zombie_check"

Dir["./spec/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include ApplicationTestHelper
end
