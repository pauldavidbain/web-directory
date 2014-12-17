module FacultyHelper

  def filter_link(title, filter)
    content_tag :div, class: "filter" do
      link_to_if (params[:filter] != filter), title, url_for(filter: filter)
    end
  end

  def faculty_nav_class
    case params[:filter]
    when 'department'
      "department_list"
    else
      "pagination pagination-blocky"
    end
  end

end
