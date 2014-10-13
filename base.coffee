module.exports = ->
  doctype 5
  html ->
    head ->
      meta charset: 'utf-8'
      title "Tinyfiles - The biggest in being small"
      meta(name: 'description', content: @description) if @description?

      link rel: 'stylesheet', href: '//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'
      link rel: 'stylesheet', href: '//spigot.nl/material/material-wfont.min.css'

      style '''
        body {
          padding-top: 50px;
        }
        header, nav, section, footer {display: block}

        p {
          font-size: 24px;
        }

        /* Customize container */
        @media (min-width: 768px) {
          .container {
            max-width: 730px;
          }
        }

        footer p {
          font-size: 16px;
        }
      '''

      script src: '//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js'

      coffeescript ->
        $(document).ready ->
          checker = $ '#filechecker'
          button = $ '#done'
          okay = false
          box = $ '#box'

          $('#file').bind 'change', ->
            if this.files[0].size > 50000
              checker.attr 'class', 'glyphicon glyphicon-exclamation-sign'
              button.attr 'disabled', true
              okay = false
            else
              checker.attr 'class', 'glyphicon glyphicon-ok'
              button.attr 'disabled', false
              okay = true

          button.click ->
            if not okay
              return

            formData = new FormData
            file = $('#file')[0].files[0]
            formData.append 'file:' + file.name, file

            $.ajax
                url: '/'
                type: 'POST'
                ### xhr: function() {  // Custom XMLHttpRequest
                    var myXhr = $.ajaxSettings.xhr();
                    if(myXhr.upload){ // Check if upload property exists
                        myXhr.upload.addEventListener('progress',progressHandlingFunction, false); // For handling the progress of the upload
                    }
                    return myXhr;
                }, ###
                success: (result) ->
                  {name} = JSON.parse result
                  box.html "Yeah! <a href=\"https://tinyfiles.eu/#{name}\">https://tinyfiles.eu/#{name}</a>"
                error: (result) ->
                  box.html result

                data: formData
                # Options to tell jQuery not to process data or worry about content-type.
                cache: false
                contentType: false
                processData: false

    body ->
      div '.container', ->
        header ->
          h1 'Tinyfiles.eu'

        p """
          Premium tiny file upload services!
          Upload files up to 50kB, which is equal to 50,000 bytes!
          Now you can finally share your pieces of assembly code or
          your public RSA keys.
        """

        hr()

        div '#box.well', ->
          div '.input-group', ->
            div '.input-group-addon', ->
              i id: 'filechecker', class: 'glyphicon glyphicon-remove'
            input '#file.form-control', type: 'file'
          div class: 'btn btn-success', id: 'done', disabled: true, 'Upload'

        hr()

        p ->
          text 'Want more than 5kB (WHY?!), please consider '
          a href: 'https://smallfiles.eu/', 'Smallfiles'
          text """
             because it can have files up to 5MB for free
            (Where do they store all these files o.o)
            and is made by a friend of mine :-)
          """

        hr()

        footer ->
          p ->
            text 'By '
            a href: 'https://dral.eu/', 'Michiel Dral'
            text ' (and a little bit of '
            a href: 'https://cas.yt/', 'Cas de Reuver'
            text ')'
