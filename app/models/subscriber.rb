class Subscriber < ApplicationRecord
  has_many :subscription_lists, :through => :subscriptions
  has_many :syndications

  validate :email, presence: true,
                   uniqueness: { case_sensitive: false }
                   :email_format
  validate :hash, presence: true
end
