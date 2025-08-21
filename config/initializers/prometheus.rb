require "prometheus_exporter/middleware"

enable_prometheus = ENV.fetch("ENABLE_PROMETHEUS") { false }
if Rails.env.production? && !!enable_prometheus
  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware, instrument: :prepend
end
