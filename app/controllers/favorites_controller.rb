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

  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end
end
