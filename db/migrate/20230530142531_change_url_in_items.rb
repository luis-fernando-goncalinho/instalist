class ChangeUrlInItems < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :url, :media
    change_column :items, :media, :string
  end
end
