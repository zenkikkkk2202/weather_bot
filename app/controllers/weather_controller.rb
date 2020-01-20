class WeatherController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

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
      
      if event.message['text'].include?("天気")
        city = event.message['text'].delete(" 天気")
        response = open_weather = "http://api.openweathermap.org/data/2.5/weather?q=#{city},jp&units=metric&lang=ja&APPID=2a8d665689d5a8d78c32f0ab119e6948"
      elsif 
        event.message['text'] == "チュートリアル"
        tutorial = "都市の名前の後ろにスペースを開けずに天気と入力してください。" 
        response = "#{tutorial}"
      elsif
        event.message['text'].include?("ぐるなび")
        store = event.message['text'].delete("ぐるなび")
        response = store = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=161a20d6368441dd8e7d27c1aa717317&address=#{store}"
      else
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
