class Post < ActiveRecord::Base
  belongs_to :entry
  has_many :users
end
