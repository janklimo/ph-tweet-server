FactoryGirl.define do
  factory :post do
    rank 1
    external_id 42
    name 'My Post'
    url 'http://www.producthunt.com/my_post'
    votes 1234
    series []
    after(:create) do |post|
      create_list(:user_maker, 1, post: post)
      create_list(:user_hunter, 1, post: post)
    end
  end
end
