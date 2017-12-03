class Subscriber < ApplicationRecord
  UUID_REGEX =  /[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/

  before_save :downcase_email

  has_many :subscriptions
  has_many :subscription_lists, :through => :subscriptions
  has_many :syndications

  validates_inclusion_of :confirmed, :in => [true, false]

  validates :uuid, format: { with: UUID_REGEX }

  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_email_format_of :email
  validates :email, :email,
                    presence: true,
                    uniqueness: { case_sensitive: false }

  def name
    return "#{first_name} #{last_name}"
  end

  def downcase_email
    self.email.downcase!
  end
end
