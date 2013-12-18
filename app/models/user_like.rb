class UserLike < ActiveRecord::Base
  attr_accessible :likable_type, :likable_id, :liker_id

  validates :likable_type, :likable_id, :liker_id, presence: true
  validates :likable_type, inclusion: {in: %w( Photo Post )}
  validate(
    :must_be_unique,
    :can_only_like_friends_object
  )

  after_create :send_notifications

  belongs_to :likable, polymorphic: true

  belongs_to(
    :liker,
    class_name: "User",
    foreign_key: :liker_id
  )

  has_many :notifications, as: :notifiable, dependent: :destroy

  private
    def must_be_unique
      if UserLike.where(
          likable_type: likable_type,
          likable_id: likable_id,
          liker_id: liker_id
        ).exists?

        errors.add(:like, "must be unique")
      end
    end

    def can_only_like_friends_object
      likable = self.likable
      # see if taggable.user_id is either mine or one of my friends'
      if !likable
        errors.add("That", "does not exist")
      end

      liker = User.find(liker_id)
      friends = liker.friends

      if likable_type == "Photo"
        unless liker_id == likable.user_id || friends.include?(User.find(likable.user_id))
          errors.add(likable_type, "must belong to your friend")
        end

      elsif likable_type == "Post"
        unless liker_id == likable.author_id || friends.include?(User.find(likable.author_id))
          errors.add(likable_type, "must belong to your friend")
        end
      end
    end

    def send_notifications
      if likable_type == "Photo"
        return if liker_id == likable.user_id

        Notification.create(
          sender_id: liker_id,
          recipient_id: likable.user_id,
          notifiable_id: likable.id,
          notifiable_type: "UserLike",
          message: "#{User.find(liker_id).name} liked your photo!"
        )

      elsif likable_type == "Post"
        return if liker_id == likable.author_id

        Notification.create(
          sender_id: liker_id,
          recipient_id: likable.author_id, # the only major difference
          notifiable_id: likable.id,
          notifiable_type: "UserLike",
          message: "#{User.find(liker_id).name} liked your post!"
        )
      end
    end
end
