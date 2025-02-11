class User < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :blogs
  has_many :comments
  # enum :role, [user: 0, admin: 1]
  # enum role: {
  #   user: 0,
  #   admin: 1
  # }
  

  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable #:confirmable
         

  def admin?
   role == 'admin'
  end

  def user?
   role == 'user'
  end
end
