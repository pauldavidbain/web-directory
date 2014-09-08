class DepartmentPresenter < ApplicationPresenter
  def social_media(type)
    send type, "Follow Us", social_list(object.social_media)
  end

  def gallery_photos(type)
    send type, "Photos", gallery_photo_list(object.gallery_photos)
  end

  def child_departments(type)
    send type, "Offices & Services", format_content(object.child_departments.where(published: true).order('title asc'), :link)
  end

  def fax(type)
    send type, "Fax", object.full_biola_phone_number(:fax)
  end

  private

  def gallery_photo_list(photos)
    photos.map do |photo|
      context.content_tag :div, '', class: 'gallery_photo', style: "background-image: url(#{photo.photo.url(:small)})", 'data-full-url' => photo.photo.url(:medium)
    end.join
  end
end
