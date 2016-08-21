class Entry < ActiveRecord::Base
  has_many :posts
  has_many :users, through: :posts
  validates :date, presence: true
end
