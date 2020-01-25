class WeatherController < ApplicationController
  require 'line/bot'  
  require "json"
  require 'uri'
  require 'net/http'
  require "open-uri"
  
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
      if 
        event.message['text'] == "チュートリアル"
        tutorial = "地名の後ろにスペースを開けずに天気と入力すると、天気予報が返ってきます \nニュースと入力するとトップニュースが返ります \n地名の後ろにスペースを開けずにぐるなびと入力すると、お店の情報が返ります \nそれ以外はおうむ返しです" 
        response = "#{tutorial}"  
      elsif 
        event.message['text'].include?("天気")
        city = event.message['text'].delete(" 天気")
        wkey = ENV["WEATHER_KEY"]
        open_weather = `curl -X GET "http://api.openweathermap.org/data/2.5/weather?q=#{city},jp&units=metric&lang=ja&APPID=#{wkey}"`
        hash_result = JSON.parse open_weather
        cod = hash_result.fetch("cod")
        if cod == 200
          tenki = hash_result.fetch("weather")[0]
          main = hash_result.fetch("main")
          response = " 天気 #{tenki.fetch("main")} \n 詳細 #{tenki.fetch("description")} \n 平均気温 #{main.fetch("temp")} \n 最高気温 #{main.fetch("temp_max")} \n 最低気温 #{main.fetch("temp_min")}" 
        else
          response = "検索結果がありません"
        end

      elsif
        #newsapiを呼び出す
        event.message['text'] == ("ニュース")
        nkey = ENV["NEWS_KEY"]
        news = "http://newsapi.org/v2/top-headlines?country=jp&apiKey=#{nkey}"
        result = `curl -s -X GET "#{news}"`
        nresult = JSON.parse result
        info = nresult.fetch("articles")[0]
        info2 = nresult.fetch("articles")[1]
        info3 = nresult.fetch("articles")[2]
        title = info.fetch("title")
        url = info.fetch("url")
        title2 = info2.fetch("title")
        url2 = info2.fetch("url")
        title3 = info3.fetch("title")
        url3 = info3.fetch("url")
        response = "タイトル #{title} \nURL #{url}\n---------------------------\nタイトル #{title2} \nURL #{url2}\n---------------------------\nタイトル #{title3} \nURL #{url3}"
      elsif
        # ぐるなびAPIを呼び出す
        event.message['text'].include?("ぐるなび","wifi")
        area = event.message['text'].delete("ぐるなび")
        gkey = ENV["GURU_KEY"]
        eurl = URI.encode("https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{gkey}&address=#{area}")
        result = `curl -s -X GET "#{eurl}"`
        eresult = JSON.parse result
        info = eresult.fetch("rest")[0]
        info2 = eresult.fetch("rest")[1]
        name = info.fetch("name")
        cate = info.fetch("category")
        url = info.fetch("url")
        name2 = info2.fetch("name")
        cate2 = info2.fetch("category")
        url2 = info2.fetch("url")
        response = "店名 #{name} \nカテゴリー #{cate} \nURL #{url}\n店名 #{name2} \nカテゴリー #{cate2} \nURL #{url2}"
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