# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# users ==================================
u1 = User.new(
  name: "Joe",
  email: "joe@example.com",
  password: "password"
)
u1.skip_confirmation!
u1.save!

u2 = User.new(
  name: "Mike",
  email: "mike@example.com",
  password: "password"
)
u2.skip_confirmation!
u2.save!

users = User.all

# wikis ==================================
1.upto(20) do
  user = users.sample
  Wiki.find_or_create_by( #Wiki.create(
    title: "#{Faker::Book.title} by #{user.name}",
    body: Faker::Hipster.paragraphs,
    user: user
    )
end



puts "*".center(40,"*")
puts
puts "#{User.standard.count} standard users created".center(40, " ")
puts "#{Wiki.count} wikis created".center(40, " ")
#puts "#{Wiki.count} all wikis created".center(40," ")
#puts "#{Wiki.where(private: false).count} public wikis created".center(40," ")
#puts "#{Wiki.where(private: true).count} private wikis created".center(40," ")
#puts "#{User.standard.count} standard users created".center(40," ")
#puts "#{User.premium.count} premium users created".center(40," ")
#puts "#{User.admin.count} admin users created".center(40," ")
puts " Done seeding ".center(40," ")
puts
puts "*".center(40,"*")



#
