FactoryGirl.define do
  factory :user do
    trait :hunter do
      role User.roles['hunter']
      name 'Jon Snow Hunter'
      twitter 'snow_hunter'
      image_url 'http://www.imgur.com/image_hunter.jpg'
    end

    trait :maker do
      role User.roles['maker']
      name 'Jon Snow Maker'
      twitter 'snow_maker'
      image_url 'http://www.imgur.com/image_maker.jpg'
    end

    factory :user_maker, traits: [:maker]
    factory :user_hunter, traits: [:hunter]
  end
end
