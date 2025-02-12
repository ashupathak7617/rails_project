class Comment < ApplicationRecord
	
	belongs_to :user
	belongs_to :blog
	
	validates :comment, presence: true
	validates :comment, length: { in: 2..20}

	scope :recent_first, -> {order(created_at: :desc)}
end
