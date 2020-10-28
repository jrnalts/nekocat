require 'line/bot'

class NekocatController < ApplicationController
  protect_from_forgery with: :null_session

  def webhook
    # 學說話
    reply_text = learn(received_text)

    # 關鍵字回覆
    reply_text = keyword_reply(received_text) if reply_text.nil?

    # 推齊
    reply_text = echo2(channel_id, received_text) if reply_text.nil?

    # 記錄對話
    save_to_received(channel_id, received_text)\
    save_to_reply(channel_id, reply_text)

    # 傳送訊息到 Line
    response = reply_to_line(reply_text)

    # 回應 200
    head :ok
  end

  # 頻道 ID
  def channel_id
    source = params['events'][0]['source']
    source['groupId'] || source['roomId'] || source['userId']
  end
  
  # 儲存對話
  def save_to_received(channel_id, received_text)
    return if received_text.nil?
    Received.create(channel_id: channel_id, text: received_text)
  end

  # 儲存回應
  def save_to_reply
    return if reply_text.nil?
    Reply.create(channel_id: channel_id, text: reply_text)
  end
  
  # 推齊功能
  def echo2(channel_id, received_text)
    # 如果在 channel_id 最近沒人講過 received_text，內扣貓就不回應
    recent_received_texts = Received.where(channel_id: channel_id).last(5)&.pluck(:text)
    return nil unless received_text.in? recent_received_texts

    # 如果在 channel_id 內扣貓上一句回應是 received_text，內扣貓就不回應
    last_reply_text = Reply.where(channel_id: channel_id).last&.text
    return nil if last_reply_text == received_text

    received_text
  end

  # 取得對方說的話
  def received_text
    message = params['events'][0]['message']
    message['text'] if not message.nil?
  end

  # 學說話
  def learn(received_text)
    # 如果開頭不是 內扣貓你說； 就跳出
    return nil if not received_text[0..5] == '內扣貓你說；'

    received_text = received_text[6..-1]
    semicolon_index = received_text.index('；')

    # 找不到分號就跳出
    return nil if semicolon_index.nil?

    keyword = received_text[ 0..semicolon_index - 1 ]
    message = received_text[ semicolon_index + 1..-1 ]

    KeywordMapping.create(keyword: keyword, message: message)
    '好~喵嗚~'
  end

  # 關鍵字回覆
  def keyword_reply(received_text)
    # 如果 DB裡有關鍵字，就將查詢結果存到 mapping
    KeywordMapping.where(keyword: received_text).last&.message

    # # 學習紀錄表
    # keyword_mapping = {
    #   '好聽的歌' => '夜に駆ける：https://www.youtube.com/watch?v=x8VYWazR5mE'
    # }

    # 查表
    # keyword_mapping[received_text]
  end

  # 傳送訊息到 Line
  def reply_to_line(reply_text)
    return nil if reply_text.nil?

    # 取得 reply token
    reply_token = params['events'][0]['replyToken']

    # 設定回覆訊息
    message = {
      type: 'text',
      text: reply_text
    }

    # 傳送訊息
    line.reply_message(reply_token, message)
  end

  # Line Bot API initialize
  def line
    @line ||= Line::Bot::Client.new { |config|
      config.channel_secret = 'dbf120339521248cd77ba07fcfec1541'
      config.channel_token = 'pAUzHQHj9q5Rd+JYysvToRrhV/QGYxMqB4fWEM0JsnNkPfvdkohFyzXzjXy9Pk9aHMpoRCPgxRIb6fRYK0Dm2xEnLnpLQ1lmKgJGKgHJXDc01DgKRDgxIFAGODp/XZ/vcn3BcQOAJXNz6JPk4dOaUQdB04t89/1O/w1cDnyilFU='
    }
  end

  # def request_headers
  #   render plain: request.headers.to_h.reject{ |key, value| 
  #     key.include? '.'
  #   }.map { |key, value|
  #     "#{key}: #{value}"
  #   }.sort.join("\n")
  # end

  # def request_body
  #   render plain: request.body
  # end

  # def response_headers
  #   render plain: response.headers.to_h.map { |key, value|
  #     "#{key}: #{value}"
  #   }.sort.join("\n")
  # end

  # def show_response_body
  #   puts "===這是設定後的response.body:#{response.body}==="
  #   render plain: "你正在看response body!"
  #   puts "===這是設定後的response.body:#{response.body}==="
  # end

  # def sent_request
  #   uri = URI('http://localhost:3000/nekocat/eat')
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http_request = Net::HTTP::Get.new(uri)
  #   http_response = http.request(http_request)

  #   render plain: JSON.pretty_generate({
  #     request_class: request.class,
  #     response_class: response.class,
  #     http_request_class: http_request.class,
  #     http_response_class: http_response.class
  #   })
  # end

  # def translate_to_korean(message)
  #   "#{message}油~"
  # end
end