FactoryGirl.define do
  factory :user do
    name "Joe"
    sequence(:email, 1) { |n| "#{name.gsub(/ /,'').downcase}#{n}@example.com" }
    password 'password'
    confirmed_at Time.now
  end
end
