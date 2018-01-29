# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SubscriptionList.create({
  name: 'Saturday Night Board Games',
  description: 'Semi-weekly board game events'
})

SubscriptionList.create({
  name: 'Epic Board Games',
  description: 'For playing 2+ hour long board games'
})

for i in 1..50
  Subscriber.seed do |s|
    s.admin_confirmed = [true, false].sample
    s.email_address = Faker::Internet.email
    s.email_confirmation_code = SecureRandom.hex
    s.email_confirmed = [true, false].sample
    s.first_name = Faker::Name.first_name
    s.last_name = Faker::Name.last_name
    s.uuid = SecureRandom.uuid
  end
end

for i in 1..10
  Event.seed do |e|
    e.capacity = Random.rand(10)+6
    e.datetime = Faker::Time.between(DateTime.now + 14, DateTime.now - 31)
    e.description = Faker::Lorem.sentence
    e.subscription_list_id = [1,2].sample
    e.uuid = SecureRandom.uuid
  end
end

for s in Subscriber.all
  for i in [[[1,2].sample], [1,2]].sample
    Subscription.seed do |ss|
      ss.subscriber_id = s.id
      ss.subscription_list_id = i
    end
  end
end

for e in Event.all
  for s in Subscriber.includes(:subscription_lists).where(subscription_lists: {id: e.subscription_list_id})
    if s.email_confirmed and s.admin_confirmed and [true, true, false].sample
      Syndication.seed do |sy|
        sy.event_id = e.id
        sy.subscriber_id = s.id
      end

      if [true, false].sample
        Rsvp.seed do |r|
          r.event_id = e.id
          r.subscriber_id = s.id
          r.response = [true, false].sample
        end
      end
    end
  end
end

