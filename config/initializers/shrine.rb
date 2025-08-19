# config/initializers/shrine.rb
require "shrine"
require "shrine/storage/s3"
require "shrine/storage/file_system"

s3_options = {
  bucket: ENV.fetch("AWS_BUCKET") { "latte" },
  access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID") { "bikinapp" },
  secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY") { "bikinapp" },
  region: ENV.fetch("AWS_REGION") { "us-east-1" },
  endpoint: ENV.fetch("AWS_ENDPOINT") { "http://10.43.72.92:9000" },
  force_path_style: ENV.fetch("AWS_FORCE_PATH_STYLE") { true }
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

# rack
Shrine.plugin :rack_response
Shrine.plugin :rack_file

# activerecord
Shrine.plugin :activerecord

# cache
Shrine.plugin :refresh_metadata
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data

# file location
Shrine.plugin :pretty_location

# attachment
Shrine.plugin :determine_mime_type
Shrine.plugin :remove_attachment
Shrine.plugin :store_dimensions, analyzer: :ruby_vips

# validation
Shrine.plugin :remove_invalid
Shrine.plugin :validation
Shrine.plugin :validation_helpers
