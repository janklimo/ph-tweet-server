class Post < ActiveRecord::Base
  belongs_to :entry
  has_many :users

  def hunter
    users.hunter.first
  end

  def makers
    users.maker
  end
end
