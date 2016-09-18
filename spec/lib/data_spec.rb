describe 'data:load_posts' do
  include_context 'rake'

  before do
    posts_double = double(body: read_fixtures(path: 'posts.json'))
    allow(ENV).to receive(:[]).with('TOKEN').and_return('123')

    # mock posts response
    allow(RestClient::Request).to receive(:execute).with(
      method: :get,
      url: 'https://api.producthunt.com/v1/posts',
      headers: {
        params: { day: (Date.today - 1).to_s },
        'Authorization': 'Bearer 123'
      }
    ).and_return posts_double

    # mock post votes response
    # page 1
    # simulate failure to load any votes
    @failed_double = double(body: "{ \"votes\": [] }")
    @votes_p1_double = double(body: read_fixtures(path: 'votes_page_1.json'))
    allow(RestClient::Request).to receive(:execute).with(
      method: :get,
      url: /\d+/,
      headers: {
        params: {order: 'asc', newer: 0},
        'Authorization': 'Bearer 123'
      }
    ).and_return(@failed_double, @votes_p1_double)
    # page 2
    @votes_p2_double = double(body: read_fixtures(path: 'votes_page_2.json'))
    allow(RestClient::Request).to receive(:execute).with(
      method: :get,
      url: /\d+/,
      headers: {
        params: {order: 'asc', newer: 4689724},
        'Authorization': 'Bearer 123'
      }
    ).and_return @votes_p2_double
  end
  it 'loads data and creates records' do
    task.invoke
    # entry
    entry = Entry.last
    expect(entry.date).to eq(Date.today - 1)

    #posts
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

    #users
    # - hunter
    expect(top_post.hunter.twitter).to eq 'jckmgn'
    expect(top_post.hunter.role).to eq 'hunter'
    expect(top_post.hunter.image_url).to eq "https://ph-avatars.imgix.net" \
      "/129066/original?auto=format&fit=crop&crop=faces&w=120&h=120"
    expect(top_post.hunter.name).to eq 'Jack Morgan'
    # - makers
    expect(top_post.makers.last.twitter).to eq 'LuisvonAhn'
    expect(top_post.makers.last.role).to eq 'maker'
    expect(top_post.makers.last.image_url).to eq "https://ph-avatars.imgix" \
      ".net/610708/original?auto=format&fit=crop&crop=faces&w=120&h=120"
    expect(top_post.makers.last.name).to eq "Luis von Ahn"

    # votes
    expect(@votes_p2_double).to have_received(:body).exactly(5).times
  end
end
