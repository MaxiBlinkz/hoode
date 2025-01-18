/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7xcolsy6lhmocdt")

  collection.createRule = "@request.auth.id != \"\" && agent.id = @request.auth.id"
  collection.updateRule = "@request.auth.id != \"\" && agent.id = @request.auth.id"
  collection.deleteRule = "@request.auth.id != \"\" && agent.id = @request.auth.id"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7xcolsy6lhmocdt")

  collection.createRule = ""
  collection.updateRule = ""
  collection.deleteRule = ""

  return dao.saveCollection(collection)
})
