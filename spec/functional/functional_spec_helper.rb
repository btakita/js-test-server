require "rubygems"
require "spec"
require "spec/autorun"
require "selenium_rc"
require "thin"
dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
require File.expand_path("#{dir}/../spec_helpers/be_http")
require File.expand_path("#{dir}/../spec_helpers/show_test_exceptions")
require File.expand_path("#{dir}/../spec_helpers/wait_for")
require "#{dir}/functional_spec_server_starter"
ARGV.push("-b")

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true

Sinatra::Application.use(JsTestServer::Server::App)

class Spec::ExampleGroup
  include WaitFor

  def self.start_servers(framework_name)
    before(:all) do
      server = SeleniumRC::Server.new("0.0.0.0", "4444")
      unless server.service_is_running?
        worker = fork do
          server.boot
          exit!
        end
      end
      trap("INT") do
        server.stop
      end
      at_exit do
        server.stop
      end

      FunctionalSpecServerStarter.new(framework_name).call
      TCPSocket.wait_for_service :host => "0.0.0.0", :port => "4444"
    end

    after(:suite) do
      FunctionalSpecServerStarter.new(framework_name).stop_thin_server
    end
  end


  def root_url
    "http://#{JsTestServer::Server::DEFAULTS[:host]}:#{JsTestServer::Server::DEFAULTS[:port]}"
  end
end
