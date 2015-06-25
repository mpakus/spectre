FactoryGirl.define do
  factory :group_event do
    name        { Faker::Lorem.words(5) }
    description { Faker::Lorem.sentence(20) }
    location    { Faker::Address.city << ', ' << Faker::Address.street_address << ' ' << Faker::Address.secondary_address }
    start_on    { Faker::Date.between(Date.today, Date.today + 7.days) }
    finish_on   { Faker::Date.between(Date.today + 10.days, Date.today + 60.days) }
  end
end
