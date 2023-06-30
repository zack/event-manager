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

  validates_email_format_of :email_address
  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false }

  validate :phone_number_formatter
  validate :opt_out_of_email_only_if_phone_number_present

  def is_moderator
    moderator === true
  end

  def name
    "#{first_name} #{last_name}"
  end

  def opt_out_of_email_only_if_phone_number_present
    if self.suppress_emails
      unless self.phone_number && self.phone_number != ''
        errors.add(:suppress_emails, 'only allowed in the presence of a phone number')
      end
    end
  end

  def phone_number_formatter
    return if !self.phone_number

    if self.phone_number == ''
      self.phone_number = nil
    end

    phone_number = self.phone_number.gsub(/\D/, '')
    unless phone_number.match(/\A\d{10}\z/)
      errors.add(:phone_number, 'is invalid')
    else
      self.phone_number = phone_number
    end
  end

  def downcase_email_address
    if self.email_address
      self.email_address.downcase!
    else # for the tests...
      ''
    end
  end
end
