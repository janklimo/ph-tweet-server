class User < ActiveRecord::Base
  belongs_to :post
  enum role: [ :hunter, :maker ]
end
