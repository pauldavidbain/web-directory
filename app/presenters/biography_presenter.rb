class BiographyPresenter < ApplicationPresenter

  def books(type)
    send type, "Books", object.books.map{|b| context.format_book(b) }.join(' ')
  end

end
