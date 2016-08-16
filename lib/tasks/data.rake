namespace :data do
  desc 'Load all the posts for a given day'
  task load_posts: :environment do
    date = Date.today - 1
    params = { day: date.to_s }
    token = ENV['TOKEN']
    res = RestClient::Request.execute(
      method: :get,
      url: 'https://api.producthunt.com/v1/posts',
      headers: {
        params: params,
        'Authorization': "Bearer #{token}"
      }
    )
    posts = JSON.parse(res.body)['posts']
    top_5 = posts.sort_by{ |p| p['votes_count'] }.reverse![0..4]

    entry = Entry.create(date: date)

    top_5.each_with_index do |post, index|
      Post.create(entry: entry, rank: index + 1, external_id: post['id'],
                 name: post['name'], url: post['discussion_url'],
                 votes: post['votes_count'])
    # TODO: save users, series
    end
  end
end
