module LinkHelper
  def social_link(account)
    icon = case account.type.to_s
    when 'linked_in' then 'linkedin-square'
    when 'facebook' then 'facebook-square'
    when 'twitter' then 'twitter-square'
    when 'gplus' then 'google-plus-square'
    when 'instagram' then 'instagram'
    when 'pinterest' then 'pinterest-square'
    when 'youtube' then 'youtube-square'
    else nil
    end

    link_to fa_icon(icon), account.url, target: '_blank'
  end

  def website_link(url)
    return nil if url.blank?

    link_to url.to_s.gsub(/^https?:\/\//, '').truncate(40)
  end
end
