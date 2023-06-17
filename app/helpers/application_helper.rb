module ApplicationHelper
  def user_has_list?
    current_user.lists.exists? # Verifica se o usuário possui pelo menos uma lista
  end

  def user_has_fav?
    current_user.favorites.exists?
  end
end
