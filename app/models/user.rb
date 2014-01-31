class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  #devise :omniauthable, :omniauth_providers => [:facebook]

  serialize :gmail_contacts, Array

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :username, :password_confirmation, :remember_me, :access_code, 
                :notification_emails, :firstname, :lastname, :gmail_contacts

  has_many :events, through: :guests
  has_many :guests, dependent: :destroy
  has_many :venues,  dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :guests, dependent: :destroy

  validates :email, :firstname, :lastname, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, :on => :create
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  #validates_format_of :username, with: /^[a-zA-Z0-9]+[a-zA-Z0-9_\-]*$/
  #validates_length_of :username, :minimum => 4, :maximum => 20
  validates_length_of :firstname, :lastname, :minimum => 1, :maximum => 20

  #validate :access_code_match, :on => :create

  scope :ordered_by_name, order('lastname ASC')

  def to_s
    if self.nil?
      "Invalid User"
    else
      fullname
    end
  end

  def access_code_match

    if self.access_code != "smoothitout"
      errors.add(:access_code, "does not match.  Ask Satyan for the correct code" )
    end
  end

  def fullname 
    [firstname, lastname].join(" ")
  end

  def invited?(event)
      !self.guests.where(:event_id => event.id).empty?
  end

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:info['email'])).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.firstname ||= auth.info.first_name
        user.lastname ||= auth.info.last_name
        #user.image = auth.info.image # assuming the user model has an image
        user.save!
      end
  end

  def get_contacts(req)
    @contacts = req.env['omnicontacts.contacts']
    #@user = request.env['omnicontacts.user']
    @emails = []
    @contacts.each do |c|
      email = c[:email].nil? ?  "" : c[:email]
      name = c[:name].nil? ?  "" : "#{c[:name]}:  "
      @emails << {label: "#{name} #{email}", value: email}
    end
    update_attribute(:gmail_contacts, @emails)
    update_attribute(:gmail_contacts_updated_at, DateTime.now)
  end

  def contacts_up_to_date? 
    !self.gmail_contacts.nil? and self.gmail_contacts_updated_at > DateTime.now - 10.days
  end

 
end
