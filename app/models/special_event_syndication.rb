class SpecialEventSyndication < ApplicationRecord
  belongs_to :special_event

  RSVP_NO = -1
  RSVP_MAYBE = 0
  RSVP_YES = 1
  RSVP_YES_AND_ONE = 2
  RSVP_YES_AND_TWO = 3
  RSVP_YES_AND_THREE = 4

  validates :email_address, uniqueness: { scope: :special_event }
end
