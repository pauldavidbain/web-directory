class DepartmentPresenter < ApplicationPresenter
  def social_media(type)
    send type, "Follow Us", social_list(object.social_media)
  end

  def gallery_photos(type)
    if object.gallery_photos.present?
      send type, "Photos", gallery_photo_list(object.gallery_photos.asc(:order))
    end
  end

  def child_departments(type)
    send type, "Offices & Services", format_content(object.child_departments.where(published: true).order('title asc'), :link)
  end

  def fax(type)
    send type, "Fax", object.full_biola_phone_number(:fax)
  end


end
