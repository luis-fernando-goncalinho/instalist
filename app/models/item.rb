class Item < ApplicationRecord
  belongs_to :list
  serialize :media, JSON

end
