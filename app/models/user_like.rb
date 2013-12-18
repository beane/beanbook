class UserLike < ActiveRecord::Base
  attr_accessible :likable_type, :likable_id, :liker_id

  validates :likable_type, :likable_id, :liker_id, presence: true
  validates :likable_type, inclusion: {in: %w( Photo Post )}
  validate(
    :must_be_unique,
    :can_only_like_friends_object
  )

  belongs_to :likable, polymorphic: true

  belongs_to(
    :liker,
    class_name: "User",
    foreign_key: :liker_id
  )

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
        errors.add(likable_type, "does not exist")
      end

      liker = User.find(liker_id)
      friends = liker.friends

      if likable_type == "Photo"
        unless liker_id == likable.user_id || friends.include?(User.find(likable.user_id))
          errors.add("Photo", "must belong to your friend")
        end

      elsif likable_type == "Post"
        unless liker_id == likable.author_id || friends.include?(User.find(likable.author_id))
          errors.add("Post", "must belong to your friend")
        end
      end
    end
end
