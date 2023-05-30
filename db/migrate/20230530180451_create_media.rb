class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.string :media_url
      t.string :media_type
      t.string :caption
      t.string :permalink
      t.datetime :timestamp
      t.string :thumbnail_url
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
