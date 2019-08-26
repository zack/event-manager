[![Build Status](https://travis-ci.org/zack/events-management.svg?branch=master)](https://travis-ci.org/zack/events-management)

### An app to manage event mailing lists and RSVPs.
Users are not required to authenticate, and will use unique URLs from emails to
access their account management pages and events pages. Administration will
require authentication. A single app can ran run multiple mailing lists, and
users can decide which lists to be on.

### Project Roadmap
* Application
  - [x] Implement config-driven mailing list name
  - [x] Implement config-driven email domain management
  - [x] Implement config-driven domain
  - [x] Implement config-driven admin email address
  - [x] Use localhost:3000 in emails for emails sent from development env
* User Registration
  - [x] A user can register an account
  - [x] A user receives a confirmation email upon registration
    - [x] The confirmation email lists their subscriptions
  - [x] The user can confirm their email address using the confirmation email
* User self-maintanence
  - [x] A user can update their name and email address
    - [x] A user receives a confirmation email to update their email address
  - [x] A user can delete their account
    - [x] All records of syndications to that user are deleted
    - [x] All records of subscriptions by that user are deleted
    - [x] All records of RSVPs by that user are deleted
  - [x] A user can update their subscriptions
    - [x] A user can subscribe from one or all subscriptions
    - [x] A user can unsubscribe from one or all subscriptions
  - [x] Add option for user to recover their UUID by submitting their email address
  - [x] A user can select to receive emails, gcal invites, or neither, for their events
* Event interaction
  - [x] A user can RSVP yes/no to an event
  - [x] A user can RSVP with a +1/2 to an event
  - [x] A user can change an existing RSVP to an event
  - [x] A user can see the number of other people RSVPd to an event
  - [x] A user can see the information about the event
* Authentication
  - [x] Implement authentication for administration
  - [x] Gate necessary endpoints with admin auth
* User administration
  - [x] An admin can see a list of all users and their confirmation statuses
  - [x] An admin can admin-confirm a user
  - [x] An admin can delete a user
* Event administration
  - [x] An admin can see all future events
  - [x] An admin can see all past events
  - [x] An admin can create an event
    - [x] The event is attached to a specific mailing list
  - [x] An admin can initiate invitations to an event
    - [x] The event generates plaintext emails for everyone who has selected that option
    - [ ] The event generates gcal invites for everyone who has selected that option
  - [x] An admin can delete an event
    - [x] A placeholder page is set up indicating the event was deleted
    - [ ] All invited users are notified that the event was deleted
  - [x] An admin can modify an event
    - [ ] All RSVPd users are notified that the event was modified
      - [ ] The admin may choose to omit this email (for, say, fixing a typo)
    - [x] A notice is placed on the page indicitating that the event was modified
  - [x] An admin can clone an existing past or future event
* Mailing list administration
  - [ ] The admin can initiate an email to all members of the global mailing list
  - [ ] The admin can initiate an email to all members of a subscription list
  - [x] The admin can edit, add, or remove subscription lists
