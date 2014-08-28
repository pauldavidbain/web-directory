if $('.photo-gallery').length > 0
  gallery = $("<div id=\"full_screen_gallery\"><div class=\"close_gallery\"><span>Close <i class=\"fa fa-times\"></i></span></div></div>")

  $(body).append(gallery)

  $('.gallery_photo').click ->
    gallery.fadeIn 300

    img = $("<img src='' />")
    gallery.prepend img
    img.attr('src', this.dataset.fullUrl)

    img.load ->
      if img.height() > window.innerHeight
        img.height(window.innerHeight - 100)

      img.css 'margin-top', (window.innerHeight - img.height()) / 2
      gallery.find('.close_gallery').width(img.width())
      gallery.addClass 'loaded'

  # Close gallery on any click
  gallery.click ->
    gallery.fadeOut 300, ->
      gallery.find('img').remove()
      gallery.removeClass 'loaded'
