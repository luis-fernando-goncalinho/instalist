class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def index
    raise
  end

  def create
    medias = params[:medias]
    name = params[:list_name]
    user = User.find(1)

    @list = List.new(name:, user:)

    if @list.save && medias.size.positive?
      # falta criar os itens de cada lista criada
      respond_to do |format|
        format.html
        format.json { render json: { list_id: @list.id, status: 'List created!' }, status: :created, formats: [:json] }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: { error: "List not created!" }, status: :unprocessable_entity, formats: [:json] }
      end
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

  def set_list
    @list = List.find(params[:id])
  end
end
