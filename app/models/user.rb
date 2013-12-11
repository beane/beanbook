require 'bcrypt'
class User < ActiveRecord::Base
  include SecureRandom

  attr_accessible :email, :password, :first_name, :last_name
  attr_reader :password

  before_validation :generate_session_token

  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, presence: true

  has_many(
    :wallposts,
    class_name: "Post",
    foreign_key: :recipient_id,
    primary_key: :id
  )

  has_many(
    :authored_posts,
    class_name: "Post",
    foreign_key: :author_id,
    primary_key: :id
  )

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email);
    return nil unless user
    return nil unless user.has_password?(password)

    user
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def has_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
     generate_session_token
     save!
  end
end
