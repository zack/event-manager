class SubscriptionList < ApplicationRecord
  has_many :events
  has_many :subscribers, :through => :subscriptions
end
