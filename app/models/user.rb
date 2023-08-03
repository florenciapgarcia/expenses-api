# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :expenses, dependent: :destroy
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  # TODO: - add regex
  validates :email, presence: true, uniqueness: true
  # validates :password, length: { minimum: 6 }, confirmation: { case_sensitive: true }
  # validates :password_confirmation, presence: true, length: { minimum: 6 }

  before_save :capitalize_name

  scope :user_data, -> { pluck(:id, :first_name, :last_name, :email) }

  def full_name
    [first_name, last_name].join(' ')
  end

  def show_user
    { name: full_name, email:, date_joined: created_at }
  end

  private

  def capitalize_name
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize if last_name.present?
  end
end
