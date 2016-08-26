describe PostSerializer do
  before do
    @post = create(:post)
  end
  context 'normal data' do
    it 'returns hunter twitter handle' do
      serializer = PostSerializer.new(@post)
      expect(serializer.serializable_hash[:hunter]).to eq 'snow_hunter'
    end
    it 'returns maker twitter handles' do
      serializer = PostSerializer.new(@post)
      expect(serializer.serializable_hash[:makers].size).to eq 1
      expect(serializer.serializable_hash[:makers]).to include 'snow_maker'
    end
  end
  context 'missing twitter handle' do
    it 'returns an empty string as the hunter twitter handle' do
      serializer = PostSerializer.new(@post)
      User.find_by(twitter: 'snow_hunter').update(twitter: nil)
      expect(serializer.serializable_hash[:hunter]).to eq ''
    end
    it 'returns an empty array as makers twitter handles' do
      serializer = PostSerializer.new(@post)
      User.find_by(twitter: 'snow_maker').update(twitter: nil)
      expect(serializer.serializable_hash[:makers]).to eq []
    end
  end
end
