class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show, :auth]

  def index
    @lists = List.all
    @user = current_user
    @user_list = List.where(user: @user)
    @list_item = Item.where(list_id: @user_list.pluck(:id))
  end

  def create
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

  def auth
    client_id = ENV.fetch("CLIENT_ID")
    client_secret = ENV.fetch("CLIENT_SECRET")
    redirect_uri = 'https://localhost:3000/auth'
    scope = 'user_profile,user_media'

    auth_url = "https://api.instagram.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=code"

    if params[:code]
      url = "https://api.instagram.com/oauth/access_token"

      body = "client_id=#{client_id}&client_secret=#{client_secret}&grant_type=authorization_code&redirect_uri=#{redirect_uri}&code=#{params[:code]}"

      response = HTTParty.post(url, { headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }, body: })
      data = response.parsed_response
      session[:access_token] = data["access_token"]

      redirect_to session[:next_auth_url]
    else
      redirect_to auth_url, allow_other_host: true
    end
  end

  def new
    if session[:access_token]
      @list = List.new
      fields = "media_url,media_type,caption,permalink,timestamp,thumbnail_url,username"
      limit = "24"

      url = "https://graph.instagram.com/me/media?access_token=#{session[:access_token]}&fields=#{fields}&limit=#{limit}"
      response = HTTParty.get(url)
      data = JSON.parse(response.body)

      @medias = data["data"]
      @next_url = data["paging"]["next"]
    else
      session[:next_auth_url] = new_list_path
      redirect_to auth_url, allow_other_host: true
    end
  end

  def edit
    if session[:access_token]
      fields = "media_url,media_type,caption,permalink,timestamp,thumbnail_url,username"
      limit = "24"

      url = "https://graph.instagram.com/me/media?access_token=#{session[:access_token]}&fields=#{fields}&limit=#{limit}"
      response = HTTParty.get(url)
      data = JSON.parse(response.body)

      @medias = data["data"]
      @next_url = data["paging"]["next"]
    else
      session[:next_auth_url] = edit_list_path(@list)
      redirect_to auth_url, allow_other_host: true
    end
  end

  def show
    @user = current_user
    @user.favorites
  end

  def update
    medias = params[:medias]

    if @list.save && medias.size.positive?
      @list.items.destroy_all
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

  def destroy
    @list.destroy
    redirect_to my_lists_path
  end

  def my_lists
    @lists = List.all
    @user = current_user
    @user_list = List.where(user: @user)
    @list_item = Item.where(list_id: @user_list.pluck(:id))
  end

  private

  def permitted_params
    params.permit!
  end

  def set_list
    @list = List.find(params[:id])
  end
end
