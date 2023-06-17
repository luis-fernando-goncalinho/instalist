class FavoritesController < ApplicationController
  before_action :set_list, only: [:create, :destroy]

  def create
    @favorite = Favorite.new(list: @list, user: current_user)

    if @favorite.save
      redirect_to list_path(@list)
    else
      redirect_to list_path(@list), status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to root_path, notice: "Favorite successfully deleted."
  end

  def index
    # @lists = List.user.favorites
    # @lists = current_user.lists.joins(:favorites).where(favorites: { user_id: current_user.id })
    # @favorite =
    @user = current_user
    # @list = List.where(user: @user)
    @user_fav_lists = @user.favorites
    @fav_lists = []
    @user_fav_lists.each do |fav_list|
      @fav_lists << List.where(id: fav_list.list_id)
    end
  end

  private

  def permitted_params
    params.permit!
  end

  def set_list
    @list = List.find(params[:list_id])
  end
end
