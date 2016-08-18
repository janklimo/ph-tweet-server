class ChartsController < ApplicationController
  def hello
    @votes = load_all_votes
  end

  def test
  end

  def show
    begin
      @entry = Entry.find_by!(date: params[:id])
    rescue ActiveRecord::StatementInvalid
      redirect_to not_found_charts_path
    end
  end

  private

  def load_all_votes
    votes = []
    newer = 0

    loop do
      batch = load_votes_batch(newer)
      votes.concat(batch)
      newer = batch.last['id']
      break if batch.size < 50
    end

    votes
  end

  def load_votes_batch(newer = 0)
    # My Slack Emoji post id: 70014
    params = {order: 'asc', newer: newer}
    token = ENV['TOKEN']
    res = RestClient::Request.execute(
      method: :get,
      url: 'https://api.producthunt.com/v1/posts/70014/votes',
      headers: {
        params: params,
        'Authorization': "Bearer #{token}"
      }
    )
    JSON.parse(res.body)['votes']
  end
end
