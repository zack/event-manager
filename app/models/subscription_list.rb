class SubscriptionList < ApplicationRecord
  has_many :events
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions

  validates :name, presence: true
  validates :description, presence: true
end
