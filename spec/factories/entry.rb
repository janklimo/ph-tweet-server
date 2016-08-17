FactoryGirl.define do
  factory :entry do
    date Date.today
    after(:create) do |entry|
      create_list(:post, 1, entry: entry)
    end
  end
end
