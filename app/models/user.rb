require 'bcrypt'
class User < ActiveRecord::Base
  include SecureRandom

  attr_accessible :email, :password, :first_name, :last_name, :profile_photo_id
  attr_reader :password

  before_validation :generate_session_token

  validates :password_digest, :first_name, :last_name, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, presence: true, uniqueness: true

  has_many(
    :tags,
    class_name: "Tag",
    foreign_key: :taggee_id
  )

  has_many(
    :outbound_tags,
    class_name: "Tag",
    foreign_key: :tagger_id
  )

  belongs_to(
    :profile_photo,
    class_name: "Photo",
    foreign_key: :profile_photo_id
  )

  has_many(
    :photos,
    class_name: "Photo",
    foreign_key: :user_id
  )

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

  has_many(
    :inbound_friendships,
    class_name: "Friendship",
    foreign_key: :inbound_friend_id,
    primary_key: :id
  )

  has_many(
    :outbound_friendships,
    class_name: "Friendship",
    foreign_key: :outbound_friend_id,
    primary_key: :id
  )

  has_many(
    :friends,
    through: :outbound_friendships,
    source: :inbound_friend,
    conditions: "friendships.pending IS false"
  )

  # doesn't show posts you made... good or bad? YOU decide!
  has_many(
    :feed_posts,
    through: :friends,
    source: :authored_posts
  )

  has_many(
    :outbound_pending_friends,
    through: :outbound_friendships,
    source: :inbound_friend,
    conditions: "friendships.pending IS true"
  )

  has_many(
    :inbound_pending_friends,
    through: :inbound_friendships,
    source: :outbound_friend,
    conditions: "friendships.pending IS true"
  )

  has_many(
    :sent_notifications,
    class_name: "Notification",
    foreign_key: :sender_id
  )

  has_many(
    :notifications,
    class_name: "Notification",
    foreign_key: :recipient_id
  )

  has_many(
    :sent_messages,
    class_name: "Message",
    foreign_key: :sender_id
  )

  has_many :conversation_users, inverse_of: :user

  has_many :conversations, through: :conversation_users, inverse_of: :users

  has_many :likes, class_name: "UserLike", foreign_key: :liker_id

  has_many :comments, class_name: "Comment", foreign_key: :user_id

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def is_friends_with?(user_id)
    return true if user_id == self.id
    friendship = Friendship
      .find_by_inbound_friend_id_and_outbound_friend_id(self.id, user_id)
    !!friendship && !friendship.pending
  end

  def hashed_messages
    hash = Hash.new { [] }

    messages = (sent_messages + received_messages).uniq.sort_by { |i| i.created_at}
    messages.each do |message|
      hash[message.conversation_id] += [message]
    end

    hash
  end

  # authentication

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
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
     generate_session_token
     save!
  end
end
