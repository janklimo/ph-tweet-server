class Entry < ActiveRecord::Base
  validates :date, presence: true
end
