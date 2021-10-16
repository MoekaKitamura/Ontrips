#Place   親21, 子249, 孫481 = トータル751
require "csv"

CSV.foreach('db/region.csv', headers: true) do |row|
  Place.create(
    name_jp: row['name_jp'],
    name_en: row['name_en'],
  )
end

@parents = Place.where(ancestry: nil)
  
CSV.foreach('db/country.csv', headers: true) do |row|
  region = row['region']
  parent = @parents.find_by(name_jp: region)
    parent.children.create(
    code: row['code'],
    name_jp: row['name_jp'],
    name_en: row['name_en'],
    )
end

CSV.foreach('db/city.csv', headers: true) do |row|
  country = row['code']
  child = Place.find_by(code: country)
    child.children.create(
    code: row['code'],
    name_jp: row['name_jp'],
    name_en: row['name_en'],
    )
end

  # 自動入力されなかった4箇所の緯度経度(country)
  um = Place.where(name_jp: "合衆国領有小離島")
  um.update(latitude: 20.423774366032127, longitude: 166.89544468782452)
  va = Place.where(name_jp: "バチカン市国")
  va.update(latitude: 41.90356049319624, longitude: 12.452661989558097)
  ps = Place.where(name_jp: "パレスチナ")
  ps.update(latitude: 32.132514367266744, longitude: 35.22118611556339)
  mk = Place.where(name_jp: "マケドニア共和国")
  mk.update(latitude: 41.64239710419572, longitude: 21.729136413080525)

# user
  user1 = User.create!(
    name: "Moeka",
    email: "moeka@g.com",
    password: "111111",
    admin: true,
    confirmed_at: Time.now,
  )
  user2 = User.create!(
    name: "Pippi",
    email: "pippi@g.com", 
    password: "111111",
    confirmed_at: Time.now,
  )
  user3 = User.create!(
    name: "Mathew",
    email: "mathew@g.com", 
    password: "111111",
    confirmed_at: Time.now,
  )
  user4 = User.create!(
    name: "Philip",
    email: "philip@g.com", 
    password: "111111",
    confirmed_at: Time.now,
  )
  user5 = User.create!(
    name: "Sho",
    email: "sho@g.com",
    password: "111111",
    confirmed_at: Time.now,
  )

# profile
  profile1 = user1.build_profile(
    id: user1.id,
    icon: "profile.jpg",
    gender: "女性",
    birthday: "1994-07-11",
    first_language: "Japanese",
    second_language: "英語",
    introduction: "今まで10ヶ国旅してきました。",
    place_id: 661,  #福岡
  )
  profile1.save

  profile2 = user2.build_profile(
    id: user2.id,
    icon: "profile.jpg",
    gender: "女性",
    birthday: "2000-07-11",
    first_language: "Japanese",
    second_language: "英語",
    introduction: "サンディエゴ出身のPippiです。海が大好きです",
    place_id: 274,  #サンディエゴ
  )
  profile2.save
  
  profile3 = user3.build_profile(
    id: user3.id,
    icon: "profile.jpg",
    gender: "男性",
    birthday: "1988-07-11",
    first_language: "English",
    second_language: "日本語",
    introduction: "Hi, I'm Mathew from Tasmania, Australia, which is a great place to visit if you like the outdoors.  I'm looking forward to meeting you!",
    place_id: 60,  #オーストラリア
  )
  profile3.save
  
  profile4 = user4.build_profile(
    id: user4.id,
    icon: "profile.jpg",
    gender: "男性",
    birthday: "1990-07-11",
    first_language: "English",
    second_language: "スペイン語",
    introduction: "Hi. My name's Phil. I've been living in Japan for 6 years and teaching at ACE since 2011. I'm from England and my hometown is Liverpool. I'm sure Liverpool needs very little introduction as its also the home of the Beatles. Penny Lane is a 5 minute walk from my house and I used to play football on Strawberry fields!",
    place_id: 40,  #イギリス
  )
  profile4.save
  
  profile5 = user5.build_profile(
    id: user5.id,
    icon: "profile.jpg",
    gender: "男性",
    birthday: "1988-07-11",
    first_language: "Japanese",
    second_language: "英語",
    introduction: "カナダ歴15年の日本人です。日本語、英語話せます。",
    place_id: 390,  #オタワ
  )
  profile5.save
  
# trip
  Trip.create!(
    title: "初めての一人旅",
    start_on: "2021-11-18",
    finish_on: "2021-11-26",
    flexible: true,
    description: "一人旅で、タイに行きます！初めてなので、おすすめの場所あれば教えてください😆😆カオサン通り行ってみたいです！",
    goal: false,
    user_id: 1,
    place_id: 440
  )

  Trip.create!(
    title: "カリフォルニアに長期滞在！",
    start_on: "2021-12-10",
    finish_on: "2021-12-26",
    flexible: true,
    description: "仕事の関係で、ロサンゼルスに滞在します。サンディエゴに車で行けるみたいなので行ってみたいです！サンディエゴ紹介してくれる方、募集中！🌴",
    goal: false,
    user_id: 1,
    place_id: 274
  )
  
# favorite
  Favorite.create!(
    user_id: 2,
    trip_id: 1,
  )

  Favorite.create!(
    user_id: 5,
    trip_id: 1,
  )

  Favorite.create!(
    user_id: 4,
    trip_id: 2,
  )

# member
  Member.create!(
    as: 1,
    user_id: 4,
    trip_id: 2,
  )

  Member.create!(
    as: 2,
    user_id: 5,
    trip_id: 2,
  )

  Member.create!(
    as: 1,
    user_id: 1,
    trip_id: 2,
  )

# comment
  Comment.create!(
    content: "おもしろそう！",
    user_id: 2,
    trip_id: 1,
  )

  Comment.create!(
    content: "ランチ美味しいとこ紹介しますよ〜〜",
    user_id: 4,
    trip_id: 1,
  )

  Comment.create!(
    content: "私も同じ時期に行きます！ぜひご一緒したいです。",
    user_id: 3,
    trip_id: 2,
  )

# talk
  Talk.create!(
    sender_id: 1,
    receiver_id: 2,
  )
  
  Talk.create!(
    sender_id: 3,
    receiver_id: 4,
  )
  
# message
  Message.create!(
    content: "こんにちは",
    talk_id: 1,
    user_id: 2,
    read: true,
  )

  Message.create!(
    content: "はじめまして！",
    talk_id: 1,
    user_id: 1,
    read: true,
  )

  Message.create!(
    content: "ありがとうございました！",
    talk_id: 2,
    user_id: 3,
    read: true,
  )

  Message.create!(
    content: "楽しかったですね(◍•ᴗ•◍)",
    talk_id: 2,
    user_id: 4,
    read: false,
  )

# blog
  Blog.create!(
    title: "ハワイ旅行の日記",
    content: "家族でハワイに行ってきました！ホテルは憧れのロイヤルハワイアン！ピンクのホテルが可愛い〜〜💓",
    user_id: 1,
  )