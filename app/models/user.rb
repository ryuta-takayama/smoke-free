class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

      
  enum reason_to_quit: { health: 0, money: 1, family: 2, work: 3, other: 4 }
end
