class ListsController < ApplicationController

  def index
    raise
  end

  def create
    @medias = params[:medias]
    @list_name = params[:list_name]

    respond_to do |format|
      format.html
      format.text { render json: { message: params }, status: :created, formats: [:json] }
    end
  end

  def new
    @list = List.new

    user_token = ENV.fetch("INSTAGRAM_USER_TOKEN")
    fields = "media_url,media_type,caption,permalink,timestamp,thumbnail_url"
    limit = "12"

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

  private

  def permitted_params
    params.permit!
  end
end
