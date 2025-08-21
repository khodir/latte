require "prometheus_exporter/middleware"

if ENV.fetch("PROMETHEUS_ENABLED", "false") == "true"
  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware, instrument: :prepend
end
