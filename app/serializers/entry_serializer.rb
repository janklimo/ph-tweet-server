class EntrySerializer < ActiveModel::Serializer
  attributes :id, :date, :makers
  has_many :posts

  def makers
    object.users.maker.where.not(twitter: nil).map { |m| m.twitter }
  end
end
