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

  validates :notifiable_type, inclusion: {in: %w( Tag Friendship Post )}

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

    end
  end
end
