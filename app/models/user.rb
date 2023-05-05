class User < ApplicationRecord
  has_many :expenses
  has_secure_password
end
