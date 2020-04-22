class User < ApplicationRecord
  has_many :authentication_tokens

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :token_authenticatable, :database_authenticatable, :trackable, :validatable
end
