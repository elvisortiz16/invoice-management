# frozen_string_literal: true

class User < ApplicationRecord
  include BCrypt

  has_many :emitter_invoices, class_name: 'Invoice', foreign_key: 'emitter_id', dependent: :nullify,
                              inverse_of: :emitter
  has_many :receiver_invoices, class_name: 'Invoice', foreign_key: 'receiver_id', dependent: :nullify,
                               inverse_of: :receiver

  # adds virtual attributes for authentication
  has_secure_password
  # validates email
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: I18n.t('user.invalid_email') }

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
