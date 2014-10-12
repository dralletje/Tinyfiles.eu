ck = require 'coffeekup'
http = require 'http'
fs = require 'fs'
multiparty = require 'multiparty'

index = ck.compile(require './base')()

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

      if part.filename? and (match = part.name.match(/file:[0-9a-zA-Z ]+(?:(\.[0-9a-zA-Z]+)*)$/))
        [_, ext] = match
        console.log ext

        if name? # Already uploaded one
          do part.resume
          return

        collection = "aeiuo"
        name = (collection[Math.floor Math.random()*collection.length] for i in [1...5]).join('') + ext
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
    res.end(index)

  else
    res.end 'WAT MOET JE?!'

.listen 1337
