class Syndication < ApplicationRecord
  belongs_to :event
  belongs_to :subscriber

  validates :subscriber, uniqueness: { scope: :event }
end
