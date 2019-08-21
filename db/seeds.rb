# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "faker"

User.create(name: "adminstrator", 
            email: "testing@example.com", 
            password: "password", 
            password_confirmation: "password")

99.times do |n|
  User.create(name: Faker::Name.name, 
              email: Faker::Internet.unique.email,
              password: "password",
              password_confirmation: "password"
  )
end