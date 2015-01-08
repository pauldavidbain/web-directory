class BiographyPresenter < ApplicationPresenter

  def books(type)
    send type, "Books", object.books.map{|b| context.format_book(b) }.join(' ')
  end

  def attachment(type)
    send type, "Documents", context.link_to("CV Document (PDF)", object.attachment.attachment.url)
  end

end
