class WeatherController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  open_weather = "http://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp&units=metric&lang=ja&APPID=2a8d665689d5a8d78c32f0ab119e6948"

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # def callback
  #   body = request.body.read

  #   signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   unless client.validate_signature(body, signature)
  #     head :bad_request
  #   end

  #   events = client.parse_events_from(body)

  #   events.each { |event|

  #     if event.message['text'] == ("三田市")
  #       response = "兵庫県"
  #     elsif event.message["text"].include?("あう")
  #       response = "あうあう"
  #     elsif event.message['text'].include?("マウマウ")
  #       response = "マウマウまう"
  #     else
  #       response = "登録されていません"
  #     end

  #     case event
  #     when Line::Bot::Event::Message
  #       case event.type
  #       when Line::Bot::Event::MessageType::Text
  #         message = {
  #           type: 'text',
  #           text: event.message['text']
  #         }
  #         client.reply_message(event['replyToken'], message)
  #       end
  #     end
  #   }

  #   head :ok
  # end
  def callback

    # Postモデルの中身をランダムで@postに格納する
    @post=Post.offset( rand(Post.count) ).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|

      # event.message['text']でLINEで送られてきた文書を取得
      if event.message['text'].include?("三田市")
        response = "兵庫県"
      elsif event.message["text"].include?("兵庫県")
        response = "三田市"
      else
        response = "登録されていません"
      end
      #if文でresponseに送るメッセージを格納

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
