class Session < ApplicationRecord
  belongs_to :user
  before_create :generate_token # Here call

  private
  def generate_token # Here implement, generate the token as you wish.
    self.token=Digest::SHA1.hexdigest([ Time.now, rand ].join)
  end
end