# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SubscriptionList.create(
  name: 'List 1',
  description: 'List 1 Description'
)

SubscriptionList.create(
  name: 'List 2',
  description: 'List 2 Description'
)

SubscriptionList.create(
  name: 'List 3',
  description: 'List 3 Description'
)

for i in 1..100
  User.seed do |s|
    email_confirmed = [true, false].sample
    s.admin_confirmed = [true, false].sample
    s.email_address = Faker::Internet.email
    s.email_confirmed = email_confirmed
    s.user_confirmed = email_confirmed && [true, false].sample
    s.first_name = Faker::Name.first_name
    s.last_name = Faker::Name.last_name
    s.uuid = SecureRandom.uuid
    s.uuid = SecureRandom.uuid
    s.invitation_type = [1].sample# , 2, 3].sample
  end
end

for i in 1..10
  Address.seed do |a|
    a.address_line_1 = Faker::Address.street_address
    a.address_line_2 = [Faker::Address.secondary_address, nil].sample
    a.city = Faker::Address.city
    a.state = Faker::Address.state_abbr
    a.zip = Faker::Address.zip
    a.special_instructions = [Faker::Lorem.sentence, nil].sample
  end
end

for i in 1..30
  Event.seed do |e|
    start_time = Faker::Time.between(from: DateTime.now + 14, to: DateTime.now - 14)

    e.address_id = [Address.all.sample.id, nil].sample
    e.capacity = Random.rand(10) + 6
    e.datetime = start_time
    e.datetime_end = start_time + 3 * 60 * 60
    e.description = Faker::Lorem.sentence
    e.subscription_list_id = [1, 2].sample
    e.uuid = SecureRandom.uuid
  end
end

for s in User.all
  for i in [1, 2, 3].filter { [true, false].sample }
    Subscription.seed do |ss|
      ss.user_id = s.id
      ss.subscription_list_id = i
    end
  end
end

for e in Event.all
  for s in User.includes(:subscription_lists).where(subscription_lists: { id: e.subscription_list_id })
    if s.email_confirmed && s.admin_confirmed && [true, true, false].sample
      Syndication.seed do |sy|
        sy.event_id = e.id
        sy.user_id = s.id
      end

      if [true, false].sample
        Rsvp.seed do |r|
          r.event_id = e.id
          r.user_id = s.id
          r.response = [true, false].sample
        end
      end
    end
  end
end
