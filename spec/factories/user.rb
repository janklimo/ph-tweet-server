FactoryGirl.define do
  factory :user do
    image_url 'http://www.imgur.com/image.jpg'
    twitter 'my_handle'

    trait :hunter do
      role User.roles['hunter']
      name 'Jon Snow Hunter'
    end

    trait :maker do
      role User.roles['maker']
      name 'Jon Snow Maker'
    end

    factory :user_maker, traits: [:maker]
    factory :user_hunter, traits: [:hunter]
  end
end
