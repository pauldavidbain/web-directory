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
    send type, "Photos", gallery_photo_list(object.gallery_photos)
  end

  private
  def gallery_photo_list(photos)
    photos.map do |photo|
      context.content_tag :div, '', class: 'gallery_photo', style: "background-image: url(#{photo.photo.url(:small)})", 'data-full-url' => photo.photo.url(:medium)
    end.join
  end

end
