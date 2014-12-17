module FacultyHelper

  def filter_link(title, filter)
    content_tag :div, class: "filter" do
      link_to_if (params[:filter] != filter), title, url_for(filter: filter)
    end
  end

end
