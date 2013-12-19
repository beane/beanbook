class Comment < ActiveRecord::Base
  attr_accessible :user_id, :body, :commentable_id, :commentable_type

  validates :user_id, :body, :commentable_id, :commentable_type, presence: true
  validates :commentable_type, inclusion: {in: %w( Photo Post )}
  validate :can_only_comment_on_friends_objects

  after_create :send_notification

  belongs_to :commentable, polymorphic: true

  has_many :user_likes, as: :likable, dependent: :destroy

  has_many :notifications, as: :notifiable, dependent: :destroy

  belongs_to :author, class_name: "User", foreign_key: :user_id

  private

    def send_notification
      n = Notification.new(
        sender_id: user_id,
        notifiable_id: id,
        notifiable_type: "Comment",
        message: "#{User.find(user_id).name} commented on your #{commentable.class.to_s.downcase}!",
      )

      if commentable.class == Photo
        recipient_id = commentable.user_id
      elsif commentable.class == Post
        recipient_id = commentable.author_id
      end

      return if user_id == recipient_id # no need to send a notification to yourself

      n.recipient_id = recipient_id
      n.save
    end

    def can_only_comment_on_friends_objects
      commentable = self.commentable
      # see if taggable.user_id is either mine or one of my friends'
      if !commentable
        errors.add("That", "does not exist")
      end

      friends = User.find(user_id).friends
      commenter = User.find(user_id)

      if commentable_type == "Photo"
        unless commentable_id == commentable.user_id || friends.include?(User.find(commentable.user_id))
          errors.add(commentable_type, "must belong to your friend")
        end

      elsif commentable_type == "Post"
        unless commentable_id == commentable.author_id || friends.include?(User.find(commentable.author_id))
          errors.add(commentable_type, "must belong to your friend")
        end
      end
    end
end
