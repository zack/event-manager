[![Build Status](https://travis-ci.org/zack/events-management.svg?branch=master)](https://travis-ci.org/zack/events-management)

### An app to manage event mailing lists and RSVPs.
Users are not required to authenticate, and will use unique URLs from emails to
access their account management pages and events pages. Administration will
require authentication. A single app can ran run multiple mailing lists, and
users can decide which lists to be on.

### Project Roadmap
* Application
  - [ ] Implement mailing list name customization
  - [ ] Implement config-driven subscription list management
  - [ ] Implement config-driven email domain management
  - [ ] Implement config-driven domain
  - [ ] Use localhost:3000 in emails for emails sent from development env
* User Registration
  - [x] A user can register an account
  - [x] A user receives a confirmation email upon registration
  - [x] The user can confirm their email address using the confirmation email
* User self-maintanence
  - [x] A user can update their name and email address
    - [ ] A user receives a confirmation email to update their email address
    - [ ] A user can revert their email address change from their account page
  - [x] A user can delete their account
    - [x] All records of syndications to that user are deleted
    - [x] All records of subscriptions by that user are deleted
    - [ ] All records of RSVPs by that user are anonymized
  - [x] A user can update their subscriptions
    - [x] A user can subscribe from one or all subscriptions
    - [x] A user can unsubscribe from one or all subscriptions
* Event interaction
  - [ ] A user receives an email for an open event if they subscribe to a list
  - [ ] A user can RSVP yes/no to an event
  - [ ] A user can RSVP with a +1/2 to an event
  - [ ] A user can change an existing RSVP to an event
  - [ ] A user can see the number of other people RSVPd to an event
  - [ ] A user can see the information about the event
* Authentication
  - [ ] Implement authentication for administration
  - [ ] Gate necessary endpoints with admin auth
* User administration
  - [ ] An admin can see a list of all users and their confirmation statuses
  - [ ] An admin can admin-confirm a user
  - [ ] An admin can delete a user
  - [ ] An admin can change a user's name
  - [ ] An admin can change a user's email address
    - [ ] A user receives a confirmation email to update their email address
    - [ ] A user can revert their email address change from their account page
* Event administration
  - [x] An admin can see all future events
  - [x] An admin can see all past events
  - [x] An admin can create an event
    - [x] The event is attached to a specific mailing list
  - [ ] An admin can initiate an email to all subscribers to the event's current list
  - [x] An admin can delete an event
    - [ ] A placeholder page is set up indicating the event was deleted
    - [ ] All RSVPd users are notified that the event was deleted
  - [x] An admin can modify an event
    - [ ] All RSVDpd users are notified that the event was modified
    - [ ] A notice is placed on the page indicitating that the event was modified
      - [ ] The admin may choose to omit this notice (for, say, fixing a typo)
  - [ ] An admin can clone an existing past or future event
