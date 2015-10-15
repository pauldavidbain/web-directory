class BiographyPresenter < ApplicationPresenter

  def books(type)
    send type, "Books", Array(object.books).map{|b| context.format_book(b) }.join(' ')
  end

  def attachment(type)
    if object.attachment.present?
      send type, "Documents", context.link_to("CV Document (PDF)", object.attachment.attachment.url)
    end
  end

  def gallery_photos(type)
    if object.gallery_photos.present?
      send type, "Photos", gallery_photo_list(object.gallery_photos.asc(:order))
    end
  end

end
