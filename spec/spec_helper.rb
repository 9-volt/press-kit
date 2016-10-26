Bundler.require :default, :test

require_relative "../main"
require "support/shared_examples"
require "support/shared_context"

VCR.configure do |config|
  config.cassette_library_dir     = "spec/cassettes"
  config.hook_into                  :webmock
  config.configure_rspec_metadata!
end
