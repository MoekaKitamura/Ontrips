require "csv"

CSV.foreach('db/region.csv', headers: true) do |row|
  Place.create(
    name_jp: row['name_jp'],
    name_en: row['name_en'],
  )
end

  # 親 21

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

  # 子 249 => 合計 270

CSV.foreach('db/city.csv', headers: true) do |row|
  country = row['code']
  child = Place.find_by(code: country)
    child.children.create(
    code: row['code'],
    name_jp: row['name_jp'],
    name_en: row['name_en'],
    )
end

  # 孫 481 = 751

  # 自動入力されなかった4箇所の緯度経度(country)
  um = Place.where(code: "UM")
  um.update(latitude: 20.423774366032127, longitude: 166.89544468782452)
  va = Place.where(code: "VA")
  va.update(latitude: 41.90356049319624, longitude: 12.452661989558097)
  ps = Place.where(code: "PS")
  ps.update(latitude: 32.132514367266744, longitude: 35.22118611556339)
  mk = Place.where(code: "MK")
  mk.update(latitude: 41.64239710419572, longitude: 21.729136413080525)

  # 自動入力されなかった4箇所の緯度経度(city)
