VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true # Headless Chrome requests
  config.ignore_hosts 'chromedriver.storage.googleapis.com'
  # config.debug_logger = STDERR
  config.configure_rspec_metadata!
end
