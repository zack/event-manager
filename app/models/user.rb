class User < ApplicationRecord
  UUID_REGEX = /\A[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\Z/

  before_save :downcase_email_address

  has_many :subscriptions
  has_many :subscription_lists, through: :subscriptions
  has_many :syndications

  validates_inclusion_of :email_confirmed, in: [true, false]
  validates_inclusion_of :admin_confirmed, in: [true, false]

  validates :uuid, format: { with: UUID_REGEX }

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email_confirmation_code

  validates_email_format_of :email_address
  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false }

  def name
    "#{first_name} #{last_name}"
  end

  def downcase_email_address
    if self.email_address
      self.email_address.downcase!
    else # for the tests...
      ''
    end
  end
end
