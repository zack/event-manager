class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :user, uniqueness: { scope: :event }

  RSVP_NO = -1
  RSVP_MAYBE = 0
  RSVP_YES = 1
  RSVP_YES_AND_ONE = 2
  RSVP_YES_AND_TWO = 3
  RSVP_YES_AND_THREE = 4

  RESPONSE_STRINGS_BY_VALUE = {
    RSVP_NO => 'No',
    RSVP_MAYBE => 'Maybe',
    RSVP_YES => 'Yes',
    RSVP_YES_AND_ONE => 'Yes + 1',
    RSVP_YES_AND_TWO => 'Yes + 2',
    RSVP_YES_AND_THREE => 'Yes + 3'
  }
end
