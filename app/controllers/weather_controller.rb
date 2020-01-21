class WeatherController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require "json"

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)
    events.each { |event|
      # open_weatherのAPIを呼び出す
      if event.message['text'].include?("天気")
        city = event.message['text'].delete(" 天気")
        response = open_weather = `curl -X GET "http://api.openweathermap.org/data/2.5/weather?q=#{city},jp&units=metric&lang=ja&APPID=2a8d665689d5a8d78c32f0ab119e6948"`
      elsif 
        event.message['text'] == "チュートリアル"
        tutorial = "都市の名前の後ろにスペースを開けずに天気と入力してください。" 
        response = "#{tutorial}"
      elsif
        # ぐるなびAPIを呼び出す
        event.message['text'].include?("ぐるなび")
        area = event.message['text'].delete("ぐるなび")
        response = `curl -X GET https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=161a20d6368441dd8e7d27c1aa717317&format=html&address=#{area}`
      else
        # おうむ返し
        event.message['text']
        same = event.message['text']
        response = "#{same}"
      end
      
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end 
    }
    head :ok
  end
  
end

  # def callback
  #   body = request.body.read

  #   signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   unless client.validate_signature(body, signature)
  #     error 400 do 'Bad Request' end
  #   end

  #   events = client.parse_events_from(body)

  #   #ここでlineに送られたイベントを検出している
  #   # messageのtext: に指定すると、返信する文字を決定することができる
  #   #event.message['text']で送られたメッセージを取得することができる
  #   events.each { |event|
  #     if event.message['text'] != nil
  #       place = event.message['text'] #ここでLINEで送った文章を取得
  #       # result = `curl -X GET http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=161a20d6368441dd8e7d27c1aa717317'&'format=json'&'address=#{place}`#ここでぐるなびAPIを叩く
  #       result = `curl -X GET https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=161a20d6368441dd8e7d27c1aa717317'&'format=json'&'address=#{place}`#ここでぐるなびAPIを叩く
  #     else
  #       latitude = event.message['latitude']
  #       longitude = event.message['longitude']
  #       result = `curl -X GET http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=161a20d6368441dd8e7d27c1aa717317'&'format=json'&'latitude=#{latitude}'&'longitude=#{longitude}`#ここでぐるなびAPIを叩く
  #     end

  #     hash_result = JSON.parse result #レスポンスが文字列なのでhashにパースする
  #     shops = hash_result["rest"] #ここでお店情報が入った配列となる
  #     shop = shops.sample #任意のものを一個選ぶ

  #     #店の情報
  #     url = shop["url_mobile"] #サイトのURLを送る
  #     shop_name = shop["name"] #店の名前
  #     category = shop["category"] #カテゴリー
  #     open_time = shop["opentime"] #空いている時間
  #     holiday = shop["holiday"] #定休日

  #     if open_time.class != String #空いている時間と定休日の二つは空白の時にHashで返ってくるので、文字列に直そうとするとエラーになる。そのため、クラスによる場合分け。
  #       open_time = ""
  #     end

  #     if holiday.class != String
  #       holiday = ""
  #     end

  #     response = "【店名】" + shop_name + "\n" + "【カテゴリー】" + category + "\n" + "【営業時間と定休日】" + open_time + "\n" + holiday + "\n" + url
  #      case event #case文　caseの値がwhenと一致する時にwhenの中の文章が実行される(switch文みたいなもの)
  #     when Line::Bot::Event::Message
  #       case event.type
  #       when Line::Bot::Event::MessageType::Text,Line::Bot::Event::MessageType::Location
  #         message = {
  #           type: 'text',
  #           text: response
  #         }
  #         client.reply_message(event['replyToken'], message)
  #       end

  #     end
  #   } 

  #   head :ok
  # end

