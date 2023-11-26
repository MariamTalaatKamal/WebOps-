class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  # has_many :tags, dependent: :destroy
  validates :tags, presence: true
end
