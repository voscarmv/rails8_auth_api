class User < ApplicationRecord
  ROLES = %w[admin manager user].freeze
  before_validation :set_default_role, on: :create
  validates :role, inclusion: { in: ROLES }
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :projects, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private
  def set_default_role
    self.role ||= "user"
  end
end
