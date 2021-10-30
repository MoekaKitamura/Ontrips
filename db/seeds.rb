# Place   親21, 子249, 孫481 = トータル751
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
admin = User.create!(
  name:"Ontrips公式アカウント",
  email:"ontrips@ex.com",
  password:"111111",
  admin: true,
  confirmed_at: Time.now,
)

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
    name: "Shota",
    email: "shota@g.com",
    password: "111111",
    confirmed_at: Time.now,
  )

# profile
  profile1 = user1.build_profile(
    id: user1.id,
    icon: "profile.jpg",
    gender: "女性",
    birthday: "1994-07-11",
    first_language: "日本語",
    second_language: "英語",
    introduction: "こんにちは！福岡出身のMoekaです！ 仕事やプライペート合わせて、渡航暦は11ヶ国です🌏✈️ マレーシアに一人旅に行った時、現地で友達を作って観光したり、ローカルの方と話していろんな体験をしたのがとても楽しかったので、またそんな旅ができたらいいなと思ってます！ぜひ一緒に旅しましょー！😆",
    place_id: 661,  #福岡
  )
  profile1.save

  profile2 = user2.build_profile(
    id: user2.id,
    icon: "profile.jpg",
    gender: "女性",
    birthday: "2000-07-11",
    first_language: "日本語",
    second_language: "英語",
    introduction: "サンディエゴ在住のPippiです。日本生まれの日本人です！🇯🇵日本語、英語どちらも話せるので、旅行に行くけど言葉通じないし不安・・・という方、ご案内しますよ〜！サンディエゴはビーチがたくさんあり、メキシカンな雰囲気も楽しめる最高の場所です！🧡🌴（気に入って住み着いてしまうくらい😬笑）ぜひ皆さんにも知って欲しいです！海外にいる友達を訪ねる感覚でお越しください！！(空き部屋あるので、宿泊も相談ください💁🏼‍♀️)",
    place_id: 274,  #サンディエゴ
  )
  profile2.save
  
  profile3 = user3.build_profile(
    id: user3.id,
    icon: "profile.jpg",
    gender: "男性",
    birthday: "1988-07-11",
    first_language: "英語",
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
    first_language: "英語",
    second_language: "スペイン語",
    introduction: "Hi. My name's Phil. I've been living in Japan for 6 years. I'm from England and my hometown is Liverpool. I'm sure Liverpool needs very little introduction as its also the home of the Beatles. Penny Lane is a 5 minute walk from my house and I used to play football on Strawberry fields!",
    place_id: 40,  #イギリス
  )
  profile4.save
  
  profile5 = user5.build_profile(
    id: user5.id,
    icon: "profile.jpg",
    gender: "男性",
    birthday: "1988-07-11",
    first_language: "日本語",
    second_language: nil,
    introduction: "最近、海外旅行にハマりました！これからどんどん旅に出たいと思います！語学は勉強中ですが、全然できないので慣れてる方とご一緒したいです！",
    place_id: 651,  #東京
  )
  profile5.save
  
# trip
  trip1 = Trip.create!(
    title: "初めての一人旅",
    start_on: "2021-11-09",
    finish_on: "2021-11-13",
    flexible: true,
    description: "一人旅で、タイに行きます！🐘初めてなので、おすすめの場所あれば教えてください😆😆カオサン通り行ってみたいです！",
    goal: false,
    user_id: user5.id,
    place_id: 440
  )

  trip2 = Trip.create!(
    title: "アメリカ横断！キャンピングカー！",
    start_on: "2021-11-10",
    finish_on: "2021-12-30",
    flexible: true,
    description: "念願のアメリカ横断！🇺🇸🗽メンバー募集します。計画は、サンディエゴスタートで、ロサンゼルスに行き、ルート66を通ってゴールはニューヨーク！🚖年齢性別国籍関係なし！6人くらいで考えてます。アメリカ在住の方、案内してくれる方も大歓迎です！",
    goal: false,
    user_id: user1.id,
    place_id: 274
  )

  trip3 = Trip.create!(
    title: "ドバイでラクダに乗りたい🐫",
    start_on: "2021-12-10",
    finish_on: "2021-12-26",
    flexible: false,
    description: "ドバイに行くのですが語学できないので、英語話せる方や、ドバイにいる日本人の方と繋がりたいです！",
    goal: false,
    user_id: user5.id,
    place_id: 283
  )

  trip4 = Trip.create!(
    title: "Trip to JAPAN!!",
    start_on: "2021-09-04",
    finish_on: "2021-09-26",
    flexible: false,
    description: "I'm planning to go to Tokyo, Kyoto and Fukuoka!! It's first time to visit Japan (even Asia!!)",
    goal: true,
    user_id: user3.id,
    place_id: 651
  )

  trip5 = Trip.create!(
    title: "クリスマスをスウェーデンで🎄🎅",
    start_on: "2021-12-10",
    finish_on: "2021-12-28",
    flexible: false,
    description: "今回初めてヨーロッパに行きます！クリスマスを本場の北ヨーロッパで過ごしたくて、旅することに決めました！一緒にいろんな貴重な体験しましょうー！！",
    goal: false,
    user_id: user2.id,
    place_id: 124
  )

  trip6 = Trip.create!(
    title: "アユタヤ遺跡でゾウに乗りタイ🐘",
    start_on: "2021-11-10",
    finish_on: "2021-11-17",
    flexible: false,
    description: "パックパッカーでタイ一周します！！アユタヤでどうしても象に乗ってみたいのですが、一緒に行きませんか？",
    goal: false,
    user_id: user1.id,
    place_id: 141
  )
  
# favorite
  Favorite.create!(
    user_id: user1.id,
    trip_id: trip1.id,
  )

  Favorite.create!(
    user_id: user2.id,
    trip_id: trip2.id,
  )

  Favorite.create!(
    user_id: user4.id,
    trip_id: trip2.id,
  )

  Favorite.create!(
    user_id: user5.id,
    trip_id: trip2.id,
  )

  Favorite.create!(
    user_id: user1.id,
    trip_id: trip4.id,
  )

# member
  Member.create!(
    as: 1,
    user_id: user4.id,
    trip_id: trip2.id,
  )

  Member.create!(
    as: 2,
    user_id: user2.id,
    trip_id: trip2.id,
  )

  Member.create!(
    as: 1,
    user_id: user5.id,
    trip_id: trip6.id,
  )

  Member.create!(
    as: 1,
    user_id: user2.id,
    trip_id: trip3.id,
  )

  Member.create!(
    as: 2,
    user_id: user5.id,
    trip_id: trip4.id,
  )


# comment
  Comment.create!(
    content: "楽しそうです！！飛行機取っちゃおうか迷います！",
    user_id: user5.id,
    trip_id: trip2.id,
  )

  Comment.create!(
    content: "こんにちは！サンディエゴ在住のPippiです！！サンディエゴからロスまでだけ参加してもいいですか？案内させてください！",
    user_id: user2.id,
    trip_id: trip2.id,
  )

  Comment.create!(
    content: "I want to visit Japan too!",
    user_id: user4.id,
    trip_id: trip4.id,
  )

  Comment.create!(
    content: "東京は案内します！",
    user_id: user5.id,
    trip_id: trip4.id,
  )

  Comment.create!(
    content: "僕も初めての一人旅でタイへ行きます！",
    user_id: user5.id,
    trip_id: trip6.id,
  )

# talk
  talk1 = Talk.create!(
    sender_id: user1.id,
    receiver_id: user2.id,
  )
  
  talk2 = Talk.create!(
    sender_id: user3.id,
    receiver_id: user4.id,
  )

  talk3 = Talk.create!(
    sender_id: user1.id,
    receiver_id: user3.id,
  )

  talk4 = Talk.create!(
    sender_id: user2.id,
    receiver_id: user4.id,
  )

  talk5 = Talk.create!(
    sender_id: user1.id,
    receiver_id: user5.id,
  )

# message
  Message.create!(
    content: "こんにちは",
    talk_id: talk1.id,
    user_id: user1.id,
    read: true,
  )

  Message.create!(
    content: "はじめまして！",
    talk_id: talk1.id,
    user_id: user2.id,
    read: false,
  )

  Message.create!(
    content: "ありがとうございました！",
    talk_id: talk2.id,
    user_id: user3.id,
    read: true,
  )

  Message.create!(
    content: "楽しかったですね(◍•ᴗ•◍)",
    talk_id: talk2.id,
    user_id: user4.id,
    read: true,
  )

  Message.create!(
    content: "次は私が行きますね！",
    talk_id: talk2.id,
    user_id: user3.id,
    read: false,
  )

# blog
  Blog.create!(
    title: "ハワイ旅行の日記🌺",
    content: "家族でハワイに行ってきました！ホテルは憧れのロイヤルハワイアン！ピンクのホテルが可愛い〜〜💓",
    user_id: user1.id,
  )

  Blog.create!(
    title: "メキシコ警察に捕まりそうになった話",
    content: "怖かったけど、今では笑える思い出！！日本と法律が違うので気をつけて！(笑)",
    user_id: user1.id,
  )

  Blog.create!(
    title: "海外旅行にはまったキッカケ",
    content: "大学の授業の一環で、海外ボランティアに参加しました。これが僕にとって、初めての海外！！",
    user_id: user5.id,
  )

  Blog.create!(
    title: "サンディエゴの魅力🌴",
    content: "学生時代に留学をしてから、大好きになったサンディエゴ。将来絶対住みたい！と思っていたので移住しました。",
    user_id: user2.id,
  )

  Blog.create!(
    title: "About my hometown Liverpool",
    content: "Did you know that Liverpool also has more World Heritage Buildings than any other city? This is thanks to our maritime heritage during the 1800s. We also have 2 cathedrals and 2 football teams.",
    user_id: user4.id,
  )