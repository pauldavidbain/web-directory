class User
  include Mongoid::Document

  field :trogdir_id, type: String
  field :username, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :biola_id, type: Integer # probably not needed once we have the trogdir_id
  field :title, type: String
  field :email, type: String
  field :photo_url, type: String
  field :department, type: String
  field :affiliations, type: Array
  field :entitlements, type: Array
  field :roles, type: Array
  alias_attribute :netid, :username

  # for logging in
  field :current_login_at, type: DateTime
  field :last_login_at, type: DateTime
  field :login_count, type: Integer

  validates :username, presence: true, uniqueness: true

  def name
    [first_name, last_name].compact.join(" ")
  end

  def to_s
    name
  end

  def has_role?(*role)
    !(roles & role.flatten.map(&:to_s)).empty?
  end

  def admin?
    has_role?(:admin)
  end

  def developer?
    has_role?(:developer)
  end

  def role_symbols
    roles ? roles.map(&:to_sym) : Array.new
  end

  def affiliations_to_sym
    affiliations.to_a.map(&:to_sym)
  end

  [:faculty, :student, :employee, :alumnus, :student_worker, :trustee].each do |affl|
    define_method "#{affl}?" do
      affiliations_to_sym.include? affl
    end
  end

  def update_login_info!
    self.last_login_at = current_login_at
    self.current_login_at = Time.now
    self.login_count = login_count.to_i + 1
    self.save
  end

  def update_from_cas!(extra_attributes)
    cas_attr = HashWithIndifferentAccess.new(extra_attributes)

    self.entitlements = User.urns_to_roles(cas_attr[:eduPersonEntitlement], Settings.urn_namespaces)
    self.affiliations = cas_attr[:eduPersonAffiliation]
    self.username ||= cas_attr[:cn].try(:first)
    self.biola_id ||= cas_attr[:employeeId].try(:first)
    self.photo_url ||= cas_attr[:url].try(:first)
    self.department ||= cas_attr[:department].try(:first)
    self.title ||= cas_attr[:title].try(:first)
    self.email ||= cas_attr[:mail].try(:first)
    self.first_name ||= cas_attr[:eduPersonNickname].try(:first)
    self.last_name ||= cas_attr[:sn].try(:first)

    self.save && self.update_roles!
  end

  def self.allowed_roles
    Authorization::Engine.instance.roles.map(&:to_s)
  end

  # Find URNs that match the namespaces and remove the namespace
  # See http://en.wikipedia.org/wiki/Uniform_Resource_Name
  def self.urns_to_roles(urns, nids)
    return [] if urns.blank?

    clean_urns = urns.map { |e| e.gsub(/^urn:/i, '') }
    clean_nids = nids.map { |n| n.gsub(/^urn:/i, '') }

    clean_urns.map { |urn|
      clean_nids.map { |nid|
        urn[0...nid.length] == nid ? urn[nid.length..urn.length] : nil
      }
    }.flatten.compact
  end

  def update_roles!
    #TODO
    self[:roles] = (affiliations + entitlements).uniq.compact
    self.save
  end
end
