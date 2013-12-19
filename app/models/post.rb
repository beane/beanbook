class Post < ActiveRecord::Base
  attr_accessible :author_id, :recipient_id, :body

  validates :author_id, :recipient_id, :body, presence: true
  validate :author_is_friends_with_recipient, :editor_is_author

  after_create :send_notification

  belongs_to(
    :recipient,
    class_name: "User",
    foreign_key: :recipient_id,
    primary_key: :id
  )

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many :tags, as: :taggable, dependent: :destroy

  has_many :tagged_users, through: :tags, source: :taggee

  has_many :notifications, as: :notifiable, dependent: :destroy

  has_many :user_likes, as: :likable, dependent: :destroy

  has_many(
    :comments,
    as: :commentable,
    dependent: :destroy,
    order: "created_at ASC"
  )

  private

    def author_is_friends_with_recipient
      friendship = Friendship
        .where(pending: false)
        .find_by_inbound_friend_id_and_outbound_friend_id(author_id, recipient_id)

      unless friendship || author_id == recipient_id
        # allowed to post on your own wall
        errors.add(:friendship, "must exist")
      end
    end

    def editor_is_author
      # this is happeneing before the save, so I can check if this post
      # is in the supposed author's posts
      if id && !User.find(author_id).authored_posts.map(&:id).include?(id)
        errors.add("You", "must own a post to edit it.")
      end
    end

    def send_notification
      return if recipient_id == author_id

      user = User.find(author_id)
      Notification.create(
        recipient_id: recipient_id,
        sender_id: author_id,
        notifiable_id: id,
        notifiable_type: "Post",
        message: "#{user.first_name} posted on your wall!"
      )
    end
end
