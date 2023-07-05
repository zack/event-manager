require 'securerandom'

class Syndication < ApplicationRecord
  belongs_to :event
  belongs_to :user
  before_validation :generate_new_identifier, on: :create

  validates :user, uniqueness: { scope: :event }

  def generate_new_identifier
    identifier = SecureRandom.base64(6)

    while identifier_is_unsafe(identifier)
      identifier = SecureRandom.base64(6)
    end

    self.identifier = identifier
  end

  private

    def identifier_is_unsafe(identifier)
      identifier.match(/\A[a-zA-Z0-9]+\z/).nil? || Syndication.where(identifier: identifier).length > 0
    end
end
