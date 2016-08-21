FactoryGirl.define do
  factory :user do
    twitter 'my_handle'

    trait :hunter do
      role User.roles['hunter']
      name 'Jon Snow Hunter'
      image_url 'http://www.imgur.com/image_hunter.jpg'
    end

    trait :maker do
      role User.roles['maker']
      name 'Jon Snow Maker'
      image_url 'http://www.imgur.com/image_maker.jpg'
    end

    factory :user_maker, traits: [:maker]
    factory :user_hunter, traits: [:hunter]
  end
end
