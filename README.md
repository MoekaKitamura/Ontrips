# README

## 本番環境 / Production
[Heroku]()

## 製品名 / Name
ontrips

## 製品概要 / Overview
新しい旅の形 〜旅の目的に"交流"を〜
旅行者が一緒に観光する仲間を探し、また、現地の方とも繋がれるアプリ

問題提議 : 日本の海外旅行人口の減少
理由として挙げられるのが、怖い、治安の不安、一緒に行く人がいない、誘って予定合わせるのが面倒・・・誰かと一緒に行きたいけど一緒に行ってくれる友達がいない・・・など

日本のパスポートは世界最強！旅に出ないのはもったいない！旅は人生を変えるきっかけにもなります。
このアプリでは、旅行したいユーザーが掲示板に自分の旅の内容を投稿します。
他のユーザーの中で同じ期間に同じ場所に行く予定のユーザーはその投稿を見て、その旅のメンバーに参加することができます。
世界中から旅行仲間を探し、さらに旅がもっと楽しいものになります。旅の中の1日だけ一緒に過ごす人も探せます。
また、旅行者としてだけでなく、自分の地元が行き先の旅投稿を見つけたら、現地人として旅に参加し、旅行者を案内したり、交流したりすることができます。
自分の街の魅力を旅行者に伝え、ガイドしてあげましょう。旅行者の新たな視点から、今まで気がつかなかった、当たり前と思っていた発見が生まれるかもしれません。
交流を深めることで世界中に友達が増え、次は自分が旅に出た時に案内してもらえるかもしれません。
世界中に訪れる友達がいるなんて、とてもワクワクしませんか？
現地をよく知る方が友達感覚でガイドしてくれるとなると、知らない土地は怖いという感情が取り除かれ、旅へのハードルが低くなり、今まで躊躇っていた人々も旅に出ることができます。
現地の方と交流することで、その旅行先のことをもっと知れて、日常では出会えない、貴重な体験ができます。
もちろん、海外に行く機会がない方は、国内旅行でも利用できます。
このアプリで、旅仲間を見つけ、世界中を旅しよう！！✈️🌏

## 開発言語 / language
- OS: Linux
- Ruby 2.6.5
- Ruby on Rails 5.2.5
- HTML, CSS, JavaScript, jQuery, Bootstrap
- DB: postgreSQL

## 就職Termの技術 / Skills(in Employment Term)
- devise
- rails_admin
- cancancan
- お気に入り機能
- コメント機能

## カリキュラム外の技術 / Skills(out of the curriculum)
- ransack
- Chartkick
- gmaps4rails
- redcarpet

## 実行手順 / Procedure
```
$ git clone https://github.com/MoekaKitamura/Original_app.git
$ cd ontrips
$ bundle install
$ rails db:create db:migrate
$ rails s
```

## 要件定義 / requirements definition

### [カタログ設計とテーブル定義書 / Catalog design & Table definition](https://docs.google.com/spreadsheets/d/1ENKwAzdYHMGjMbthwnVfu-RVuUPE5uRBg9CM09zGx9c/edit?usp=sharing)

### ER図 / Entity Relationship Diagram
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/ER.png)

### 画面遷移図 / Screen transition diagram
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/Screen_Transition.png)

### ワイヤーフレーム / Wire frame
https://shared-assets.adobe.com/link/ea5c967c-ed7b-40ef-40ae-1b8aee92661b
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/wire_flame.png)
