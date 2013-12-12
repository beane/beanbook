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
  outbound_friend_id: brian.id
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

books = Post.create!(
  author_id: brian.id,
  recipient_id: margaret.id,
  body: "Why don't you have a real Facebook account?"
)

super_saiyan = Post.create!(
  author_id: goku.id,
  recipient_id: brian.id,
  body: "I am the alpha and the omega! I am the bacon in the fridge for all mankind!"
)

response = Post.create!(
  author_id: margaret.id,
  recipient_id: brian.id,
  body: "Because being rich and famous gets old after a while."
)

brian_status = Post.create!(
  author_id: brian.id,
  recipient_id: brian.id,
  body: "Boy do I wish more people used beanbook."
)