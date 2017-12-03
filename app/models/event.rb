class Event < ApplicationRecord
  belongs_to :subscription_list
  has_many :subscribers, through: :syndications

  validates :date, presence: true,
                   uniqueness: true
  validates :description, presence: true
  validates :time, presence: true
end
