class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true
end
