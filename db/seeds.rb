# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user_1 = User.create(name: "John", email: "john@example.com")
user_2 = User.create(name: "Susan", email: "susan@example.com")

party1 = ViewingParty.create(duration: "2 hours", party_date: DateTime.now, party_time: Time.now, movie_id: 550, host_id: user_2.id)
party2 = ViewingParty.create(duration: "2 hours", party_date: DateTime.now, party_time: Time.now, movie_id: 550, host_id: user_1.id)

UserParty.create(user: user_1, viewing_party: party1 )
UserParty.create(user: user_2, viewing_party: party1 )

UserParty.create(user: user_1, viewing_party: party2 )
