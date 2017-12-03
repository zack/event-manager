class Subscription < ApplicationRecord
  belongs_to :subscriber
  belongs_to :subscription_list

  validates :subscriber, presence: true,
                         uniqueness: { scope: :subscription_list }
  validates :subscription_list, presence: true
end
