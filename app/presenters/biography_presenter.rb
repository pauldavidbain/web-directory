class BiographyPresenter < ApplicationPresenter

  def books(type)
    send type, "Books", Array(object.books).map{|b| context.format_book(b) }.join(' ')
  end

  def attachment(type)
    if object.attachment.present?
      send type, "Documents", context.link_to("CV Document (PDF)", object.attachment.attachment.url)
    end
  end

end
