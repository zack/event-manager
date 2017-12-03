class Subscription < ApplicationRecord
  belongs_to :subsriber
  belongs_to :subsription_list

  validates :subscriber, presence: true,
                         uniqueness: { scope: :subscription_list }
  validates :subscription_list, presence: true
end
