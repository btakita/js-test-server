module JsTestServer::Server
  DEFAULTS = {
    :host => "0.0.0.0",
    :port => 8080,
    :spec_path => File.expand_path("./spec/javascripts"),
    :root_path => File.expand_path("./public"),
  }
end

dir = File.dirname(__FILE__)
require "#{dir}/server/runner"
require "#{dir}/server/resources"
require "#{dir}/server/representations"
require "#{dir}/server/app"