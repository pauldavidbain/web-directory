Group.class_eval do
  def to_param
    slug.presence || id.to_s
  end
end
