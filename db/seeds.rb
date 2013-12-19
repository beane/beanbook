# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create users

brian = User.create!(
  email: "bean@beanbook.io",
  password: "password",
  first_name: "Brian",
  last_name: "Deane"
)

goku = User.create!(
  email: "goku@beanbook.io",
  password: "password",
  first_name: "Son",
  last_name: "Goku"
)

margaret = User.create!(
  email: "margaret@beanbook.io",
  password: "password",
  first_name: "Margaret",
  last_name: "Atwood"
)

m = User.create!(
  email: "m",
  password: "password",
  first_name: "James",
  last_name: "Bond"
)

no_friends = User.create!(
  email: "sad@sad.com",
  password: "password",
  first_name: "Sad",
  last_name: "Person"
)

# create friendships

Friendship.create!(
  inbound_friend_id: brian.id,
  outbound_friend_id: goku.id
)

Friendship.create!(
  inbound_friend_id: goku.id,
  outbound_friend_id: brian.id
)

Friendship.create!(
  inbound_friend_id: margaret.id,
  outbound_friend_id: goku.id
)

Friendship.create!(
  inbound_friend_id: goku.id,
  outbound_friend_id: margaret.id
)

Friendship.create!(
  inbound_friend_id: brian.id,
  outbound_friend_id: margaret.id
)

# plan to use this friend to check pending features
Friendship.create!(
  inbound_friend_id: brian.id,
  outbound_friend_id: no_friends.id
)

Friendship.create!(
  inbound_friend_id: m.id,
  outbound_friend_id: brian.id
)

# create posts

dbz = Post.create!(
  author_id: brian.id,
  recipient_id: goku.id,
  body: "Save us, Goku!"
)

# books = Post.create!(
#   author_id: brian.id,
#   recipient_id: margaret.id,
#   body: "Why don't you have a real Facebook account?"
# )

super_saiyan = Post.create!(
  author_id: goku.id,
  recipient_id: brian.id,
  body: "I am the alpha and the omega! I am the bacon in the fridge for all mankind!"
)

# response = Post.create!(
#   author_id: margaret.id,
#   recipient_id: brian.id,
#   body: "Because being rich and famous gets old after a while."
# )

brian_status = Post.create!(
  author_id: brian.id,
  recipient_id: brian.id,
  body: "Boy do I wish more people used beanbook."
)

Post.create!(
  author_id: no_friends.id,
  recipient_id: no_friends.id,
  body: "I want some friends please."
)

Post.create!(
  author_id: margaret.id,
  recipient_id: margaret.id,
  body: "I should get a real Facebook..."
)

# create photos

beach = Photo.create!(
  photo_file: File.open(File.expand_path("./app/assets/images/profile_photos/beach.jpeg")),
  user_id: brian.id,
  caption: "This is a great shot!"
)

flowers = Photo.create!(
  photo_file: File.open(File.expand_path("./app/assets/images/profile_photos/flowers.jpeg")),
  user_id: brian.id,
  caption: "Whoa!"
)
burger =  Photo.create!(
  photo_file: File.open(File.expand_path("./app/assets/images/profile_photos/burger.jpeg")),
  user_id: goku.id,
  caption: "Dude!"
)

portal = Photo.create!(
  photo_file: File.open(File.expand_path("./app/assets/images/profile_photos/e9cc_portal_bookends_closeup.jpg")),
  user_id: margaret.id,
  caption: "Beautiful"
)

space = Photo.create!(
  photo_file: File.open(File.expand_path("./app/assets/images/profile_photos/space-hubble-2010_1622267i.jpg")),
  user_id: brian.id,
  caption: "I wonder how this happened..."
)

# create profile pictures

brian.profile_photo_id = beach.id
brian.save!

goku.profile_photo_id = burger.id
goku.save!

margaret.profile_photo_id = space.id
margaret.save!

m.profile_photo_id = flowers.id
m.save!

no_friends.profile_photo_id = portal.id
no_friends.save!

# create a few tags

Tag.create!(
  taggable_type: "Photo",
  taggable_id: space.id,
  tagger_id: goku.id,
  taggee_id: brian.id
)

Tag.create!(
  taggable_type: "Photo",
  taggable_id: portal.id,
  tagger_id: goku.id,
  taggee_id: margaret.id
)

Tag.create!(
  taggable_type: "Photo",
  taggable_id: burger.id,
  tagger_id: goku.id,
  taggee_id: brian.id
)

# create some conversations and messages

bm = Conversation.create
bm.user_ids = [brian.id, margaret.id]

bgm = Conversation.create
bgm.user_ids = [brian.id, goku.id, margaret.id]

james_bond = Conversation.create
james_bond.user_ids = [brian.id, m.id]

bm.messages.create!(
  sender_id: brian.id,
  body: "Hey there! How have you been?"
)

bm.messages.create!(
  sender_id: margaret.id,
  body: "Mighty fine, and yourself?"
)

bgm.messages.create!(
  sender_id: brian.id,
  body: "Goku, save us!"
)

bgm.messages.create!(
  sender_id: goku.id,
  body: "Seriously, stop that!"
)

bgm.messages.create!(
  sender_id: margaret.id,
  body: "I'm with Brian on this one."
)

james_bond.messages.create!(
  sender_id: m.id,
  body: "I am very secretive..."
)

james_bond.messages.create!(
  sender_id: brian.id,
  body: "Yeah, I get that."
)


mad = Comment.create!(
  user_id: goku.id,
  body: "You mad bro?",
  commentable_id: Post.first.id,
  commentable_type: "Post"
)

Comment.create!(
  user_id: brian.id,
  body: "Yup",
  commentable_id: Post.first.id,
  commentable_type: "Post"
)

Comment.create!(
  user_id: goku.id,
  body: "You mad bro?",
  commentable_id: Photo.first.id,
  commentable_type: "Photo"
)

# like some photos

UserLike.create!(
  likable_type: "Photo",
  likable_id: beach.id,
  liker_id: brian.id
)

UserLike.create!(
  likable_type: "Photo",
  likable_id: burger.id,
  liker_id: brian.id
)

UserLike.create!(
  likable_type: "Photo",
  likable_id: beach.id,
  liker_id: goku.id
)

# like some posts

UserLike.create!(
  likable_type: "Post",
  likable_id: brian_status.id,
  liker_id: brian.id
)

UserLike.create!(
  likable_type: "Post",
  likable_id: brian_status.id,
  liker_id: goku.id
)

# like a comment

UserLike.create!(
  likable_type: "Comment",
  likable_id: mad.id,
  liker_id: brian.id
)
