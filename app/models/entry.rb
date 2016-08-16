class Entry < ActiveRecord::Base
  has_many :posts
  validates :date, presence: true
end
