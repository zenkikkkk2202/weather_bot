アプリケーション名　
　”サーチボット”

概要
　linebotの一種で、ニュース、天気、レストランの検索を行っていただけます

説明
　このアプリケーションではlineのMessagingAPIをベースに、open_weather、Japan news API、ぐるなびレストラン検索APIの三つのAPIを実装しました。
　それぞれのAPIに対応したメッセージを送信していただくと、各々の情報が送り返される仕様になっています。
 
機能
　１　都市名の後にスペースを開けずに”天気”と入力していただくと、三時間ごとに区切られたその都市の天気の予報を返信します。（天気、詳細、平均気温、最高気温、最低気温）
　２　”ニュース”と入力していただくと、その時点での日本国内のトップニュースが新しいものから順に３つ返信されます。
　３　都市名の後にスペースを開けずに”ぐるなび”と入力していただくと、検索結果の中からランダムで１つの店舗情報が返信されます。
　４　上記の３つ以外のメッセージを入力していただくと、送信された内容と同じ内容が返信されます。
　５　上記の使用方法につきましては、”チュートリアル”と入力していただければいつでも確認していただけます。
 
必要要件
　lineのインストール
 
使い方
　lineをインストールした後、このアプリケーションにメッセージを送信する。
 
デプロイ
　Herokuにてデプロイ
 
ライセンス
　ぐるなび　"https://api.gnavi.co.jp/api/img/credit/api_265_65.gif" 
  NewsAPI "https://newsapi.org/"
  Open_weather "https://openweathermap.org/api"

Application name
 "searchbot"

Overview
 It is kind of linebot, and you can search news, weather and restaurants.

Explanation
 This application was based on linebot and has three functions.
 Open weather API, Japan News API and Gurunabi restaurants search API.
 If you send message that corresponding to each API, you can get information about it.
 
Function
 1 If you send message including place name and "天気" without space, this bot returns weather of that city(weather,      description,average temperature, highest temperature and lowest temperature)
 2 If you send message "ニュース", this bot returns three Japanese news from newest one.
 3 If you send message including place name and "ぐるなび" without space, this bot returns one restaurant ramdomly from result of search
 4 If you send message that does not include above-mentioned information, this bot returns same message.
 5 You can check how to use this bot by sending message "チュートリアル" anytime
 
 Requirements
  Line installed
  
 How to use
  After Line installed, send message to this bot.
  
 Deploy
  Deployed by Heroku.
  
 License
  Gurunabi "https://api.gnavi.co.jp/api/img/credit/api_265_65.gif" 
  NewsAPI "https://newsapi.org/"
  Open_weather "https://openweathermap.org/api"
 









