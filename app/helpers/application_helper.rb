module ApplicationHelper
  def biola_person_image(netid, size=:medium)
    if netid.present?
      if netid.is_a?(Person)
        person = netid
        person.profile_photo_url || netid_to_image(person.biola_id, size)
      else
        netid_to_image(netid, size)
      end
    end
  end

  def netid_to_image(netid, size=:medium)
    digest = Digest::MD5.hexdigest(netid.to_s)
    "https://apps.biola.edu/idphotos/#{digest}_#{size.to_s}.jpg"
  end
end
