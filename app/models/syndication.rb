class Syndication < ApplicationRecord
  belongs_to :event
  belongs_to :subscriber

  validate :subscriber, uniqueness: { scope: :event }
end
