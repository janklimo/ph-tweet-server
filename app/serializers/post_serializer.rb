class PostSerializer < ActiveModel::Serializer
  attributes :id, :hunter, :makers, :url, :rank

  def hunter
    object.hunter.twitter
  end

  def makers
    object.users.maker.where.not(twitter: [nil, '']).map { |m| m.twitter }
  end
end
