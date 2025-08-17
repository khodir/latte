## schema :
perusahaan_id: `fk`
nama_category: `string`
keterangan: `string`
created_by: `string`
updated_by: `string`

## relation :
- item_category: `has_many`
- perusahaan: `belongs_to`
