MongoClient = (require 'mongodb').MongoClient

module.exports =
  open: (callback) ->
    MongoClient.connect "mongodb://#{process.env['MONGODB_HOST']}:#{process.env['MONGODB_PORT']}/popular_convention2", (err, db) ->
      return callback(err) if err?
      dbserver = db
      worklogs = dbserver.collection 'worklogs'
      conventions = dbserver.collection 'conventions'
      score = dbserver.collection 'score'

      if process.env['NODE_ENV'] is 'production'
        db.authenticate process.env["MONGODB_USER"], process.env["MONGODB_PASS"], (err, result) ->
          return callback(err) if err? or result isnt true

          # ensure index
          dbserver.ensureIndex 'conventions', {timestamp: 1}, (err) ->
            return callback(err) if err?
            dbserver.ensureIndex 'score', {shortfile: 1, lang: 1, file: 1}, (err) ->
              return callback(err) if err?

              callback()
      else
        # ensure index
        dbserver.ensureIndex 'conventions', {timestamp: 1}, (err) ->
          return callback(err) if err?
          dbserver.ensureIndex 'score', {shortfile: 1, lang: 1, file: 1}, (err) ->
            return callback(err) if err?

            callback()