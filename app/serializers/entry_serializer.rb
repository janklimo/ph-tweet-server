class EntrySerializer < ActiveModel::Serializer
  attributes :id, :date, :makers, :hunters
  has_many :posts

  def makers
    object.users.maker.where.not(twitter: [nil, ""]).map { |m| m.twitter }
  end

  def hunters
    object.users.hunter.where.not(twitter: [nil, ""]).map { |m| m.twitter }
  end
end
