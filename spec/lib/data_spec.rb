describe 'data:load_posts' do
  include_context 'rake'

  before do
    posts_double = double(body: read_fixtures(path: 'posts.json'))
    allow(ENV).to receive(:[]).with('TOKEN').and_return('123')
    allow(RestClient::Request).to receive(:execute).with(
      method: :get,
      url: 'https://api.producthunt.com/v1/posts',
      headers: {
        params: { day: (Date.today - 1).to_s },
        'Authorization': 'Bearer 123'
      }
    ).and_return posts_double
  end
  it 'loads data and creates records' do
    task.invoke
    entry = Entry.last
    expect(entry.date).to eq(Date.today - 1)
    expect(entry.posts.count).to eq 5
    top_post = entry.posts.first
    expect(top_post.rank).to eq 1
    expect(top_post.external_id).to eq 70131
    expect(top_post.name).to eq 'Tinycards by Duolingo'
    expect(top_post.url).to eq "https://www.producthunt.com/tech/" \
      "tinycards-by-duolingo?utm_campaign=producthunt-api&" \
      "utm_medium=api&utm_source=Application%3A+Momentum+Analyzer" \
      "+%28ID%3A+3237%29"
    expect(top_post.votes).to eq 1303
  end
end
