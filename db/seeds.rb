# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SubscriptionList.create({name: 'Saturday Night Board Games',
                         description: 'Roughly semi-weekly board game events'})

SubscriptionList.create({name: 'Epic Board Games',
                         description: 'For playing 2+ hour long board games'})
