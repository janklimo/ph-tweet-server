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

    top_5.each_with_index do |p, index|
      post = entry.posts.create(rank: index + 1, external_id: p['id'],
                                name: p['name'],
                                url: p['discussion_url'],
                                votes: p['votes_count'])
      hunter = p['user']
      post.users << build_user(role: :hunter, data: hunter)

      makers = p['makers']
      makers.each do |maker|
        post.users << build_user(role: :maker, data: maker)
      end
    end
  end
end

def build_user(role:, data:)
  User.create(role: role, twitter: data['twitter_username'],
              image_url: data['image_url']['120px'],
              name: data['name'])
end
