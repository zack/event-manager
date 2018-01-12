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

for i in 1..20
  Subscriber.seed do |s|
    s.admin_confirmed = false
    s.email_address = "test#{i}@exampe.com"
    s.email_confirmation_code = SecureRandom.hex
    s.email_confirmed = [true, false].sample
    s.first_name = Faker::Name.first_name
    s.last_name = Faker::Name.last_name
    s.uuid = SecureRandom.uuid
  end
end

for i in 1..5
  Event.seed do |e|
    e.capacity = Random.rand(10)+6
    e.datetime = Faker::Time.between(DateTime.now - 365, DateTime.now)
    e.description = Faker::Lorem.sentence
    e.subscription_list_id = [1,2].sample
    e.uuid = SecureRandom.uuid
  end
end

for e in Event.all
  for s in Subscriber.all
    Rsvp.seed do |r|
      r.event_id = e.id
      r.subscriber_id = s.id
      r.response = [true, false, nil].sample
    end
  end
end

