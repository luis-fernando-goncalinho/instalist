class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def index
    @lists = List.all
    @user = current_user
    @user_list = List.where(user: @user).limit(3)
    @list_item = Item.where(list_id: @user_list.pluck(:id))
  end

  def create
    # Recebe via params os campos medias e name, enviados via fetch no JS
    medias = params[:medias]
    name = params[:list_name]
    user = current_user

    @list = List.new(name:, user:)

    if @list.save && medias.size.positive?
      medias.each do |media| # Cria items de uma dada lista
        @item = Item.create!(media:, list: @list)
      end
      respond_to do |format| # Responde chamada do JS no formato JSON com id da lista criada
        format.html
        format.json { render json: { list_id: @list.id, status: 'List created!' }, status: :created, formats: [:json] }
      end
    else
      respond_to do |format| # Responde chamada do JS no formato JSON estado de erro
        format.html
        format.json { render json: { error: "List not created!" }, status: :unprocessable_entity, formats: [:json] }
      end
    end
  end

  def new
    @list = List.new

    user_token = ENV.fetch("INSTAGRAM_USER_TOKEN")
    fields = "media_url,media_type,caption,permalink,timestamp,thumbnail_url"
    limit = "24"

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
