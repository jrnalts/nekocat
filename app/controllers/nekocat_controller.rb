require 'line/bot'

class NekocatController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render plain: "罐罐呢？"
  end

  def request_headers
    render plain: request.headers.to_h.reject{ |key, value| 
      key.include? '.'
    }.map { |key, value|
      "#{key}: #{value}"
    }.sort.join("\n")
  end

  def request_body
    render plain: request.body
  end

  def response_headers
    render plain: response.headers.to_h.map { |key, value|
      "#{key}: #{value}"
    }.sort.join("\n")
  end

  def show_response_body
    puts "===這是設定後的response.body:#{response.body}==="
    render plain: "歐拉歐拉歐拉"
    puts "===這是設定後的response.body:#{response.body}==="
  end

  def webhook
    # Line Bot API initial
    client = Line::Bot::Client.new { |config|
      config.channel_secret = 'dbf120339521248cd77ba07fcfec1541'
      config.channel_token = 'pAUzHQHj9q5Rd+JYysvToRrhV/QGYxMqB4fWEM0JsnNkPfvdkohFyzXzjXy9Pk9aHMpoRCPgxRIb6fRYK0Dm2xEnLnpLQ1lmKgJGKgHJXDc01DgKRDgxIFAGODp/XZ/vcn3BcQOAJXNz6JPk4dOaUQdB04t89/1O/w1cDnyilFU='
    }

    # gey reply token
    reply_token = params['events'][0]['replyToken']

    # set reply message
    message = {
      type: 'text'
      text: '好～喵嗚～'
    }

    # send message
    response = client.reply_message(reply_token, message)

    # respond 200
    head :ok
  end

  def sent_request
    uri = URI('http://localhost:3000/nekocat/eat')
    http = Net::HTTP.new(uri.host, uri.port)
    http_request = Net::HTTP::Get.new(uri)
    http_response = http.request(http_request)

    render plain: JSON.pretty_generate({
      request_class: request.class,
      response_class: response.class,
      http_request_class: http_request.class,
      http_response_class: http_response.class
    })
  end

  def translate_to_korean(message)
    "#{message}油~"
  end
end