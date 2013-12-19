class Notification < ActiveRecord::Base

  attr_accessible(
    :recipient_id,
    :sender_id,
    :notifiable_id,
    :notifiable_type,
    :message
  )

  validates(
    :recipient_id,
    :sender_id,
    :notifiable_id,
    :notifiable_type,
    :message,
    presence: true
  )

  validates :notifiable_type, inclusion: {in: %w( Tag Friendship Post Message UserLike Comment)}

  belongs_to(
    :recipient,
    class_name: "User",
    foreign_key: :recipient_id
  )

  belongs_to(
    :sender,
    class_name: "User",
    foreign_key: :sender_id
  )

  belongs_to :notifiable, polymorphic: true

  def params
    id = notifiable_id

    case notifiable_type
    when "Tag"
      object = notifiable.taggable
      user_id = object.class == Photo ? object.user_id : object.author_id
      {
        controller: object.class.to_s.downcase.pluralize,
        action: "show",
        id: object.id,
        user_id: user_id
      }

    when "Post"
      {
        controller: "posts",
        action: "show",
        id: id
      }

    when "Friendship"
      if message[0] == "Y" # from "You are now friends with..."
        {
          controller: "users",
          action: "show",
          id: sender_id
        }

      else
        {
          controller: "friends",
          action: "index",
          user_id: recipient_id
        }
      end

    when "Message"
      {
        controller: "conversations",
        action: "show",
        id: notifiable.conversation.id # the notifiable is a message, the route is a conversation
      }

    when "UserLike"
      likable = notifiable.likable

      if likable.class == Photo
        {
          controller: "photos",
          action: "show",
          id: likable.id,
          user_id: likable.user_id
        }
      elsif likable.class == Post
        {
          controller: "posts",
          action: "show",
          id: likable.id
        }

      elsif likable.class == Comment
        hash = {
          controller: likable.commentable.class.to_s.downcase.pluralize,
          action: "show",
          id: likable.commentable.id
        }

        hash[:user_id] = likable.user_id if likable.commentable.class == Photo

        hash
      end

    when "Comment"
      commentable = notifiable.commentable
      if commentable.class == Photo
        {
          controller: "photos",
          action: "show",
          id: commentable.id,
          user_id: commentable.user_id
        }
      elsif commentable.class == Post
        {
          controller: "posts",
          action: "show",
          id: commentable.id
        }
      end
    end
  end
end
