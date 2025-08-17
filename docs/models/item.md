## schema :
perusahaan_id: `fk`
kode_item: `string`
nama_item: `string`
keterangan: `string`
created_by: `string`
updated_by: `string`

## relation :
- item_category: `has_many`
- perusahaan: `belongs_to`