class User < ActiveRecord::Base
  include Humanity::Base
  alias_attribute :netid, :username

  scope :custom_search, -> query {
    where('username LIKE ? OR first_name LIKE ? OR last_name LIKE ?', *(["%#{query}%"]*3)) unless query.blank?
  }

  def can_impersonate?
    self.developer?
  end

  def short_name
    "#{self.first_name} #{self.last_name[0,1]}.".strip
  end

  def affiliations
    @affiliations ||= roles.where(Humanity::Assignment.by_source(:affilation))
  end

  def entitlements
    @entitlements ||= roles.where(Humanity::Assignment.by_source(:entitlement))
  end

  def authorized_roles
    roles & Authorization::Engine.instance.roles.map(&:to_s)
  end

  def update_from_cas!(extra_attributes)
    cas_attr = HashWithIndifferentAccess.new(extra_attributes)

    entitlements = User.urns_to_roles(cas_attr[:eduPersonEntitlement], Settings.urn_namespaces)

    self.username ||= cas_attr[:cn].try(:first)
    self.photo_url ||= cas_attr[:url].try(:first)
    self.title ||= cas_attr[:title].try(:first)
    self.email ||= cas_attr[:mail].try(:first)
    self.first_name ||= cas_attr[:eduPersonNickname].try(:first)
    self.last_name ||= cas_attr[:sn].try(:first)

    self.save \
    && self.update_roles!(cas_attr[:eduPersonAffiliation], :affiliation) \
    && self.update_roles!(entitlements, :entitlement)
  end

  # Find URNs that match the namespaces and remove the namespace
  # See http://en.wikipedia.org/wiki/Uniform_Resource_Name
  def self.urns_to_roles(urns, nids)
    urns ||= []  # urns can sometimes be nil
    clean_urns = urns.map { |e| e.gsub(/^urn:/i, '') }
    clean_nids = nids.map { |n| n.gsub(/^urn:/i, '') }

    clean_urns.map { |urn|
      clean_nids.map { |nid|
        urn[0...nid.length] == nid ? urn[nid.length..urn.length] : nil
      }
    }.flatten.compact
  end

end