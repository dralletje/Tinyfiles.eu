ck = require 'coffeekup'
http = require 'http'
fs = require 'fs'
multiparty = require 'multiparty'

http.createServer (req, res) ->
  if req.url isnt '/'
    res.end 'Nee, ga weg :\'\'\'\'\'\'('
    return

  if req.method is 'POST'
    form = new multiparty.Form()
    name = null

    # Errors may be emitted
    form.on 'error', (err) ->
      console.log ':-(', err
      res.end 'Hmm, nee'

    # Parts are emitted when parsing the form
    form.on 'part', (part) ->
      if part.byteCount > 50000
        do part.resume
        return

      if part.filename? and part.name is 'file'
        if name? # Already uploaded one
          do part.resume
          return

        collection = "aeiuo"
        name = (collection[Math.floor Math.random()*collection.length] for i in [1...5]).join ''
        console.log('got file named ', name);
        part.pipe(fs.createWriteStream('./direct/'+name))

      else
        # Not a file...
        do part.resume

    # Close emitted after form parsed
    form.on 'close', ->
      console.log 'Bye!'
      res.end JSON.stringify what: 'Done uploading', name: name

    form.parse(req)

  else if req.method is 'GET'
    delete require.cache['/Users/Michiel/Projects/tinyfiles.eu/base.coffee']
    try
      base = ck.compile(require './base')
      res.end(base())
    catch e
      console.log e
      req.end "Kut Rikk, blijf weg."

  else
    res.end 'WAT MOET JE?!'

.listen 1337
