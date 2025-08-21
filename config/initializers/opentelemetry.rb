# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/instrumentation/all"

# configure open telemetry
if ENV.fetch("OPENTELEMETRY_ENABLED", "false") == "true"
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "latte"
    c.use_all() # enables all instrumentation!
  end
end
