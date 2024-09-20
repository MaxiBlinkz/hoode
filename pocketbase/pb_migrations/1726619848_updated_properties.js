/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7xcolsy6lhmocdt")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "kmc9p4vh",
    "name": "agent_id",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "qfmb8ewwnboi9u7",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7xcolsy6lhmocdt")

  // remove
  collection.schema.removeField("kmc9p4vh")

  return dao.saveCollection(collection)
})
