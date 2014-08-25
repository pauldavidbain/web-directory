class DepartmentPresenter < ApplicationPresenter
  def social_media(type)
    send type, "Follow Us", social_list(object.social_media)
  end

  def gallery_photos(type)
    send type, "Photos", gallery_photo_list(object.gallery_photos)
  end

  private

  def gallery_photo_list(photos)
    photos.map do |photo|
      context.content_tag :div, '', class: 'gallery_photo', style: "background-image: url(#{photo.photo.url})"
    end.join
  end
end
