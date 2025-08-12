# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/instrumentation/all"

# configure open telemetry
if Rails.env.production?
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "latte"
    c.use_all() # enables all instrumentation!
  end
end
