class Entry < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :users, through: :posts
  validates :date, presence: true
end
