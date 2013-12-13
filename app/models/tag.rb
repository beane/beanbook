class Tag < ActiveRecord::Base
  attr_accessible(
    :taggable_type,
    :taggable_id,
    :x_pos,
    :y_pos,
    :tagger_id,
    :taggee_id
  )

  validates :taggable_type, :taggable_id, :tagger_id, :taggee_id, presence: true
  validates :taggable_type, inclusion: {in: %w{ Post Photo }}
  validate(
    :can_only_tag_friend,
    :can_only_tag_on_friends_objects,
    :tag_must_be_unique
  )

  after_create :send_notification

  belongs_to(
    :tagger,
    class_name: "User"
  )

  belongs_to(
    :taggee,
    class_name: "User"
  )

  belongs_to :taggable, polymorphic: true


  has_many(
    :notifications,
    as: :notifiable,
    dependent: :destroy
  )

  private

    def can_only_tag_friend
      unless User.find(tagger_id).friends.map(&:id).include?(taggee_id) || taggee_id == tagger_id
        errors.add(:taggee_id, "is not your friend")
      end
    end

    def can_only_tag_on_friends_objects
      taggable = self.taggable
      # see if taggable.user_id is either mine or one of my friends'
      if !taggable
        errors.add(taggable_type, "does not exist")
      end

      if tagger_id != taggable.user_id && !User.find(tagger_id).friends.map(&:id).include?(taggable.user_id)
        errors.add(:taggable_id, "must belong to one of your friends")
      end
    end

    def tag_must_be_unique
      if Tag.find_by_taggable_type_and_taggable_id_and_taggee_id(taggable_type, taggable_id, taggee_id)
        errors.add(:tag, "already exists")
      end
    end

    def send_notification
      return if tagger_id == taggee_id
      user = User.find(tagger_id)
      Notification.create(
        recipient_id: taggee_id,
        sender_id: tagger_id,
        notifiable_id: taggable_id,
        notifiable_type: "Tag",
        message: "#{user.first_name} tagged you in a #{taggable_type.downcase}!"
      )
    end

end