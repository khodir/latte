# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/instrumentation/all"
# require "opentelemetry/instrumentation/rails"
# require "opentelemetry/instrumentation/active_record"
# require "opentelemetry/instrumentation/action_pack"
# require "opentelemetry/instrumentation/action_view"
# require "opentelemetry/instrumentation/active_job"

# configure for development
ENV["OTEL_TRACES_EXPORTER"] = "otlp" if !ENV["OTEL_TRACES_EXPORTER"]
ENV["OTEL_EXPORTER_OTLP_PROTOCOL"] = "http/protobuf" if !ENV["OTEL_EXPORTER_OTLP_PROTOCOL"]
ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] = "http://10.43.97.33:4318" if !ENV["OTEL_EXPORTER_OTLP_ENDPOINT"]

# configure open telemetry
OpenTelemetry::SDK.configure do |c|
  c.service_name = "latte"
  c.use_all() # enables all instrumentation!
  # c.use "OpenTelemetry::Instrumentation::Rails"
  # c.use "OpenTelemetry::Instrumentation::ActiveRecord"
  # c.use "OpenTelemetry::Instrumentation::ActionPack"
  # c.use "OpenTelemetry::Instrumentation::ActionView"
  # c.use "OpenTelemetry::Instrumentation::ActiveJob"
end
