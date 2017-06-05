FactoryGirl.define do
  factory :wiki do
    title "Wiki title"
    body "this is the wiki body"
    private false
    user
  end
end
