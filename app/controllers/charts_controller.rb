class ChartsController < ApplicationController
  PH_ORANGE = "#da552f"

  def hello
    @entries = Entry.includes(:posts).order(date: :desc)
  end

  def show
    begin
      @entry = Entry.includes(:posts).find_by!(date: params[:id])
      @chart_data = @entry.posts.order(:rank).map do |post|
        { name: "##{post.rank} #{post.name}", data: post.series }
      end
      if params[:rank].present?
        rank = (1..5).include?(params[:rank].to_i) ?
          params[:rank].to_i : 1
      else
        rank = 1
      end
      @post = @entry.posts.find_by(rank: rank)
      @colors = ["#353535", "#6d6d6d", "#8d8d8d", "#aeaeae", "#dddddd"]
      @colors[rank - 1] = PH_ORANGE
    rescue ActiveRecord::StatementInvalid
      redirect_to not_found_charts_path
    end
  end

  def data
    begin
      @entry = Entry.find_by!(date: params[:id])
      render json: @entry
    rescue ActiveRecord::StatementInvalid
      redirect_to not_found_charts_path
    end
  end
end
