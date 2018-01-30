class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription_list

  validates :user, presence: true,
                         uniqueness: { scope: :subscription_list }
  validates :subscription_list, presence: true
end
