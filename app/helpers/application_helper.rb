module ApplicationHelper
  def user_has_list?
    current_user.lists.exists? # Verifica se o usuário possui pelo menos uma lista
  end
end
