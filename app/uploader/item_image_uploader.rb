class ItemImageUploader < Shrine
  plugin :download_endpoint, prefix: "item/images"

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/jpg]
  end
end
