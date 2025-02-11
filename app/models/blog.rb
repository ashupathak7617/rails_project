class Blog < ApplicationRecord
	belongs_to :user
	has_many :comments, dependent: :destroy
	validates :title ,:content, presence: true
	validates :title, length: { minimum: 5 }
  validates :content, length: { minimum: 20 } 
end
