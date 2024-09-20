/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qfmb8ewwnboi9u7")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "3gbphkxa",
    "name": "avatar",
    "type": "file",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "mimeTypes": [],
      "thumbs": [],
      "maxSelect": 1,
      "maxSize": 5242880,
      "protected": false
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qfmb8ewwnboi9u7")

  // remove
  collection.schema.removeField("3gbphkxa")

  return dao.saveCollection(collection)
})
