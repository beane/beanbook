class Post < ActiveRecord::Base
  attr_accessible :author_id, :recipient_id, :body

  validates :author_id, :recipient_id, :body, presence: true
  validate :author_is_friends_with_recipient

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

  private

    def author_is_friends_with_recipient
      friendship = Friendship
        .where(pending: false)
        .find_by_inbound_friend_id_and_outbound_friend_id(author_id, recipient_id)

      if !friendship && author_id != recipient_id
        # allowed to post on your own wall
        errors.add(:friendship, "must exist")
      end
    end
end
