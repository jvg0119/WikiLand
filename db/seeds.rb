# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# users ==================================
admin = User.new(
  name: "Admin",
  email: "admin@example.com",
  password: "password",
  role: 'admin'
)
admin.skip_confirmation!
admin.save!

u1 = User.new(
  name: "Joe",
  email: "joe@example.com",
  password: "password",
  role: 'premium'
)
u1.skip_confirmation!
u1.save!

u2 = User.new(
  name: "Mike",
  email: "mike@example.com",
  password: "password",
  role: 'premium'
)
u2.skip_confirmation!
u2.save!

u3 = User.new(
  name: "John",
  email: "john@example.com",
  password: "password"
)
u3.skip_confirmation!
u3.save!

u4 = User.new(
  name: "George",
  email: "george@example.com",
  password: "password"
)
u4.skip_confirmation!
u4.save!

u5 = User.new(
  name: "Jane",
  email: "jane@example.com",
  password: "password"
)
u5.skip_confirmation!
u5.save!

users = User.all

# public wikis ==================================
1.upto(100) do
  user = users.sample
  Wiki.find_or_create_by( #Wiki.create(
    title: "#{Faker::Book.title} -- public wikis -- by #{user.name}",
    body: Faker::Hipster.paragraph,
    user: user
    )
end

# private wikis =================================
premium_users = [u1, u2]

1.upto(50) do
  user = premium_users.sample
  Wiki.find_or_create_by( #Wiki.create(
    title: "#{Faker::Book.title} -- private wikis -- by #{user.name}",
    body: Faker::Hipster.paragraph,
    user: user,
    private: true
    )
end

# collaborations ==================================
collaborators = [u2, u3, u4]
private_wikis = Wiki.where(private: true)
1.upto(10) do
  Collaborator.create(
  user: collaborators.sample,
  wiki: private_wikis.sample
  )
end

# =================================================
puts "*".center(40,"*")
puts
puts "#{User.standard.count} standard users created".center(40, " ")
puts "#{User.premium.count} premium users created".center(40, " ")
puts "#{User.admin.count} admin users created".center(40, " ")
puts
puts "#{Wiki.where(private: false).count} public wikis created".center(40, " ")
puts "#{Wiki.where(private: true).count} private wikis created".center(40, " ")
puts "#{Wiki.count} total wikis created".center(40, " ")
puts
puts "#{Collaborator.count} collaborators created".center(40, " ")
puts
puts " Done seeding ".center(40," ")
puts
puts "*".center(40,"*")

# =====================================================
