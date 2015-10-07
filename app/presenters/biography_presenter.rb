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

  private
  def gallery_photo_list(photos)
    context.content_tag :div, class: 'popup-gallery' do
      photos.map do |photo|
        context.content_tag :a, context.image_tag(photo.photo.url(:thumb)), href: photo.photo.url(:medium), title: photo.caption
      end.join.html_safe
    end
  end

end
