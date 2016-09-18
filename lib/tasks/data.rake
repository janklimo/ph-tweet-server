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

    entry.posts.each do |post|
      puts "Updating votes series for #{post.name}, ranked ##{post.rank}..."
      votes_data = load_all_votes(post.external_id)
      sum = 0
      # votes can appear a couple days before the product is officially posted
      # we record these votes but don't show them on the chart
      series = votes_data
        .group_by_hour { |v| v['created_at'] }
        .map { |k, v| [k, sum += v.size] }
        .select { |e| e[0] >= 25.hours.ago }
      post.update(series: series)
      puts "#{post.name}, ranked ##{post.rank} updated!"
    end
    puts "Done!"
  end
end

def build_user(role:, data:)
  User.create(role: role, twitter: data['twitter_username'],
              image_url: data['image_url']['120px'],
              name: data['name'])
end

def load_all_votes(id)
  votes = []
  newer = 0

  loop do
    # occasionally, PH server will return votes as []
    # retry loading votes if that happens
    begin
      batch = load_votes_batch(id, newer)
      votes.concat(batch)
      newer = batch.last['id']
      break if batch.size < 50
    rescue NoMethodError
      puts "Loading votes failed, retrying."
      retry
    end
  end

  votes
end

def load_votes_batch(id, newer = 0)
  # My Slack Emoji post id: 70014
  params = {order: 'asc', newer: newer}
  token = ENV['TOKEN']
  res = RestClient::Request.execute(
    method: :get,
    url: "https://api.producthunt.com/v1/posts/#{id}/votes",
    headers: {
      params: params,
      'Authorization': "Bearer #{token}"
    }
  )
  JSON.parse(res.body)['votes']
end
