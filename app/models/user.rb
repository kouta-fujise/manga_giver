class User < ApplicationRecord

  has_secure_password

  validates :email, {presence:true,uniqueness: true}
  validates :password, {length:{maximum: 20}}

  # validates :address1, {presence:true}
  # validates :address2, {presence:true}
  # validates :address3, {presence:true}
  # validates :address4, {presence:true}
  # validates :address5, {presence:true}


end
