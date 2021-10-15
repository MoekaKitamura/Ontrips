class Profile < ApplicationRecord
  belongs_to :user

  mount_uploader :icon, IconUploader

  belongs_to :place

  enum gender: { 男性: 1, 女性: 2, その他: 3 }
  enum home_country: { 日本: 1, オーストラリア: 2, アメリカ: 3 }
  enum home_city: { 福岡: 1, 東京: 2, 大阪: 3 }
  enum first_language: ["Icelandic", "Azeerbaijani", "Afrikaans", "Amharic", "Arabic", "Albanian", "Armenian", "Italian", "Indonesian", "Ukrainian", "Uzbek", "Urdu", "English", "Estonian", "Dutch", "Catalan", "Galician", "Korean", "Cantonese", "Kannada", "Greek", "Gujarati", "Khmer", "Croatian", "Javanese", "Georgian", "Sinhala", "Swedish", "Zulu", "Spanish", "Slovak", "Slovenian", "Swahili", "Sundanese", "Serbian", "Thai", "Tamil", "Czech", "Chinese", "Telugu", "Danish", "German", "Turkish", "Japanese", "Nepali", "Norwegian", "Basque", "Hungarian", "Panjabi", "Hindi", "Filipino", "Finnish", "French", "Bulgarian", "Vietnamese", "Hebrew", "Persian", "Bengali", "Polish", "Bosnian", "Portuguese", "Macedonian", "Marathi", "Malayalam", "Malay", "Burmese", "Mongolian", "Lao", "Latvian", "Lithuanian", "Romanian", "Russian"], _suffix: true #多重定義防止trueの場合は、属性名と同じ
  enum second_language: ["アイスランド語", "アゼルバイジャン語", "アフリカーンス語", "アムハラ語", "アラビア語", "アルバニア語", "アルメニア語", "イタリア語", "インドネシア語", "ウクライナ語", "ウズベク語", "ウルドゥー語", "英語", "エストニア語", "オランダ語", "カタルーニャ語", "ガリシア語", "韓国語", "広東語", "カンナダ語", "ギリシャ語", "グジャラート語", "クメール語", "クロアチア語", "ジャワ語", "ジョージア語", "シンハラ語", "スウェーデン語", "ズールー語", "スペイン語", "スロバキア語", "スロベニア語", "スワヒリ語", "スンダ語", "セルビア語", "タイ語", "タミル語", "チェコ語", "中国語", "テルグ語", "デンマーク語", "ドイツ語", "トルコ語", "日本語", "ネパール語", "ノルウェー語", "バスク語", "ハンガリー語", "バンジャーブ語", "ヒンディー語", "フィリピノ語", "フィンランド語", "フランス語", "ブルガリア語", "ベトナム語", "ヘブライ語", "ペルシャ語", "ベンガル語", "ポーランド語", "ボスニア語", "ポルトガル語", "マケドニア語", "マラーティー語", "マラヤーラム語", "マレー語", "ミャンマー語", "モンゴル語", "ラオ語", "ラトビア語", "リトアニア語", "ルーマニア語", "ロシア語"], _suffix: true
end

