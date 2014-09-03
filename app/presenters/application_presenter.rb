class ApplicationPresenter
  attr_reader :context, :object

  def initialize(view_context, object)
    @context = view_context
    @object = object
  end

  def render(type, method, options={})
    return nil if object.blank?

    # Policy should return true if you have permission to see the attribute.
    return nil if options[:policy] && !context.policy(object).send(options[:policy])

    # This is if you have custom logic. true means the item won't get shown.
    return nil if options[:hidden]

    # To add custom content logic, just create a method with the corresponding method name
    if self.respond_to? method
      send method, type
    else
      send type, (options[:title] || method.to_s.titleize), (options[:content] || format_content(@object.send(method), options[:format]))
    end
  end

  private

  ###############
  #### Types ####
  ###############
  #
  # Each of the following methods correspond to the `type` field in the `render` method above
  #

  def section(title, content)
    if content.present?
      context.content_tag(:h4, title, class: 'section-title') +
      context.content_tag(:div, safe_html(content), class: 'section-content')
    end
  end

  def row(title, content)
    if content.present?
      context.content_tag(:tr) do
        context.content_tag(:th, title, class: 'section-content') +
        context.content_tag(:td, safe_html(content), class: 'section-content')
      end
    end
  end



  #######################
  #### Helper Methods ###
  #######################

  def safe_html(content)
    if content.is_a? Array
      array_to_list(content)
    elsif content.respond_to? :html_safe
      content.html_safe
    else
      content
    end
  end

  def array_to_list(array)
    context.content_tag(:ul) do
      array.map{|c| context.content_tag(:li, c) }.join.html_safe
    end
  end

  def format_content(content, format)
    if content.is_a? Array
      content.map{|c| format_individual_content(c, format) }
    else
      format_individual_content(content, format)
    end
  end

  def format_individual_content(content, format)
    return nil if content.blank?
    case format
    when :email
      context.mail_to content, content
    when :link
      context.link_to content, content
    else
      content
    end
  end

  def social_list(media)
    media.map do |account|
      context.content_tag :div, context.social_link(account), class: 'link'
    end.join
  end
end
