describe Post, type: :model do
  describe 'hunter' do
    before do
      @post = create(:post)
    end
    it 'returns hunter of the post as a single record' do
      expect(@post.hunter.name).to eq 'Jon Snow Hunter'
    end
  end
  describe 'makers' do
    before do
      @post = create(:post)
    end
    it 'returns makes of the post as an array of records' do
      expect(@post.makers.size).to eq 1
      expect(@post.makers.first.name).to eq 'Jon Snow Maker'
    end
  end
end
