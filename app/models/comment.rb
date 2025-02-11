class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :blog
	validates :comment, presence: true
end
