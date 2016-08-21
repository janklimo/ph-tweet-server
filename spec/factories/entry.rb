FactoryGirl.define do
  factory :entry do
    date { Date.today - 1 }
  end
end
