class ListsController < ApplicationController

  def index
  end

  def create
  end

  def new
    user_token = ENV.fetch("INSTAGRAM_USER_TOKEN")
    fields = "media_url,media_type,caption,permalink,timestamp"
    limit = "10"

    url = "https://graph.instagram.com/me/media?access_token=#{user_token}&fields=#{fields}&limit=#{limit}"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    @medias = data["data"]
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
