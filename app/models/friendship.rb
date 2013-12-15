class Friendship < ActiveRecord::Base
  attr_accessible :inbound_friend_id, :outbound_friend_id

  validates :inbound_friend_id, :outbound_friend_id, presence: true
  validates :inbound_friend_id, uniqueness: {scope: :outbound_friend_id}
  validates :pending, inclusion: {in: [true, false]}

  after_save :complete_friendship

  belongs_to(
    :inbound_friend,
    class_name: "User",
    foreign_key: :inbound_friend_id,
    primary_key: :id
  )

  belongs_to(
    :outbound_friend,
    class_name: "User",
    foreign_key: :outbound_friend_id,
    primary_key: :id
  )

  has_many(
    :notifications,
    as: :notifiable,
    dependent: :destroy
  )

  private

    def complete_friendship
      friendship = Friendship
        .find_by_inbound_friend_id_and_outbound_friend_id(
          self.outbound_friend_id,
          self.inbound_friend_id
        )

      if self.pending && friendship && friendship.pending
        friendship.pending = false
        friendship.save
        self.pending = false
        save

        notify_friends
      elsif self.pending
        notify_pending
      end

      true
    end


    def notify_friends
      user_out = User.find(outbound_friend_id)
      user_in = User.find(inbound_friend_id)

      message = "You are now friends with "

      Notification.create(
        recipient_id: outbound_friend_id,
        sender_id: inbound_friend_id,
        notifiable_id: id,
        notifiable_type: "Friendship",
        message: "#{message} #{user_in.name}!"
      )

      Notification.create(
        recipient_id: inbound_friend_id,
        sender_id: outbound_friend_id,
        notifiable_id: id,
        notifiable_type: "Friendship",
        message: "#{message} #{user_out.name}!"
      )
    end

    def notify_pending
      Notification.create(
        recipient_id: inbound_friend_id,
        sender_id: outbound_friend_id,
        notifiable_id: id,
        notifiable_type: "Friendship",
        message: "#{User.find(outbound_friend_id).name} would like to be your friend!"
      )
    end
end