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
    controller = notifiable_type.downcase.pluralize
    id = notifiable_id

    case notifiable_type
    when "Tag"

    when "Post"
      # , only_path: false
      {controller: controller, action: "show", id: id, user_id: notifiable.recipient}
    when "Friendship"

    end
  end
end
