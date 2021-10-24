# README

![image](https://github.com/MoekaKitamura/Original_app/blob/master/app/assets/images/header_logo.png)

## 製品概要 / Overview
新しい旅の形 〜あなたの旅に"交流"を〜 🌏 <br>
旅行者が一緒に観光する仲間を探し、また、現地の方とも繋がれるアプリ

日本のパスポート保有者がビザなしで渡航可能または到着ビザで入国できるのは１９３カ国・地域。そんな世界最強のパスポートを持つ権利のある日本人のパスポート取得率は、わずか４人に１人・・・。<br>
旅に出ないのはもったいない！旅は人生を変えるきっかけにもなります。<br>
#### このアプリで、旅仲間を見つけ、世界中を旅しよう！！✈️🌏

## 本番環境 / Production


## 開発言語 / Language
- OS: Linux
- Ruby 2.6.5
- Ruby on Rails 5.2.5
- HTML, CSS, JavaScript, jQuery, Bootstrap
- DB: postgreSQL

## 就職Termの技術 / Skills(in Employment Term)
- devise
- rails_admin
- cancancan
- rexml
- devise-i18n
- コメント機能(Ajax)
- ダイレクトメッセージ機能(Ajax)

## カリキュラム外の技術 / Skills(out of the curriculum)
- ransack
- chartkick(地図機能)
- geocoder
- ancestry(多階層カテゴリ)
- font-awesome-sass
- kaminari + jscrollで無限スクロール(jquery-rails使用)

## 実行手順 / Procedure
```
$ git clone https://github.com/MoekaKitamura/Original_app.git
$ cd ontrips
$ bundle install
$ rails db:create db:migrate
$ rails db:seed
$ rails s
```

## 要件定義 / Requirements Definition

### カタログ設計とテーブル定義書 / Catalog Design & Table Definition
使用ソフト: Google Sheets<br>
https://docs.google.com/spreadsheets/d/1ENKwAzdYHMGjMbthwnVfu-RVuUPE5uRBg9CM09zGx9c/edit?usp=sharing

### ER図 / Entity Relationship Diagram
使用ソフト: draw.io
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/ER2.png)

### 画面遷移図 / Screen Transition Diagram
使用ソフト: draw.io
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/Screen_Transition.png)

### ワイヤーフレーム / Wire Frame
使用ソフト: Adobe Illustrator
![image](https://github.com/MoekaKitamura/Original_app/blob/master/docs/wire_frame.png)
