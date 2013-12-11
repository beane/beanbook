class Friendship < ActiveRecord::Base
  attr_accessible :inbound_friend_id, :outbound_friend_id

  validates :inbound_friend_id, :outbound_friend_id, presence: true
  validates :pending, inclusion: {in: [true, false]}

  before_save :complete_friendship

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

  private

    def complete_friendship
      # should happen in a transaction?
      friendship = Friendship
        .find_by_inbound_friend_id_and_outbound_friend_id(
          self.outbound_friend_id,
          self.inbound_friend_id
        )

      if friendship && friendship.pending
        friendship.pending = false
        friendship.save # should i rescue errors here?
        self.pending = false
      end

      true
    end
end