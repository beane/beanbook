class Tag < ActiveRecord::Base
  attr_accessible :taggable_type, :taggable_id, :x_pos, :y_pos, :tagger_id, :taggee_id

  validates :taggable_type, :taggable_id, :tagger_id, :taggee_id, presence: true
  validates :taggable_type, inclusion: {in: %w{ Post Photo }}

  belongs_to(
    :tagger,
    class_name: "User"
  )

  belongs_to(
    :taggee,
    class_name: "User"
  )

  belongs_to :taggable, polymorphic: true

  # maybe write inbound and outbound messages
end