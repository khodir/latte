require "prometheus_exporter/middleware"

if Rails.env.production? && ENV.fetch("ENABLE_PROMETHEUS", "false") == "true"
  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware, instrument: :prepend
end
