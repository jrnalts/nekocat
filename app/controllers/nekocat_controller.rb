# frozen_string_literal: true

require 'line/bot'

# controll nekocat chatbot response behavior
class NekocatController < ApplicationController
  protect_from_forgery with: :null_session

  def webhook
    # 學說話
    reply_text = learn(channel_id, received_text)

    # 關鍵字回覆
    reply_text = keyword_reply(channel_id, received_text) if reply_text.nil?

    # 推齊
    reply_text = echo2(channel_id, received_text) if reply_text.nil?

    # 記錄對話
    save_to_received(channel_id, received_text)
    save_to_reply(channel_id, reply_text)

    reply_to_line(reply_text)

    head :ok
  end

  def channel_id
    source = params['events'][0]['source']
    source['groupId'] || source['roomId'] || source['userId']
  end

  def save_to_received(channel_id, received_text)
    return if received_text.nil?

    Received.create(channel_id: channel_id, text: received_text)
  end

  def save_to_reply(channel_id, reply_text)
    return if reply_text.nil?

    Reply.create(channel_id: channel_id, text: reply_text)
  end

  def echo2(channel_id, received_text)
    # 如果在 channel_id 最近沒人講過 received_text，內扣貓就不回應
    recent_received_texts = Received.where(channel_id: channel_id).last(5)&.pluck(:text)
    return nil unless received_text.in? recent_received_texts

    # 如果在 channel_id 內扣貓上一句回應是 received_text，內扣貓就不回應
    last_reply_text = Reply.where(channel_id: channel_id).last&.text
    return nil if last_reply_text == received_text

  def response_headers
    render plain: response.headers.to_h.map { |key, value|
      "#{key}: #{value}"
    }.sort.join("\n")
  end

  def received_text
    message = params['events'][0]['message']
    message['text'] if not message.nil?
  end

  def learn(received_text)
    return nil if not received_text[0..5] == '內扣貓你說；' # 如果開頭不是 內扣貓你說； 就跳出

    received_text = received_text[6..-1]
    semicolon_index = received_text.index('；')
    return nil if semicolon_index.nil? # 找不到分號就跳出

    keyword = received_text[0..semicolon_index - 1]
    message = received_text[semicolon_index + 1..-1]

    KeywordMapping.create(channel_id: channel_id, keyword: keyword, message: message)
  end

  # 關鍵字回覆
  def keyword_reply(channel_id, received_text)
    message = KeywordMapping.where(channel_id: channel_id, keyword: received_text).last&.message
    return message unless message.nil?

    # 如果 DB裡有關鍵字，就將查詢結果存到 mapping
    KeywordMapping.where(keyword: received_text).last&.message
  end

  def reply_to_line(reply_text)
    return nil if reply_text.nil?

    # 取得 reply token
    reply_token = params['events'][0]['replyToken']

    # 設定回覆訊息
    message = {
      type: 'text',
      text: reply_text
    }

    line.reply_message(reply_token, message)
  end

  # Line Bot API initialize
  def line
    @line ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['channel_secret']
      config.channel_token = ENV['channel_token']
    }

    # gey reply token
    reply_token = params['events'][0]['replyToken']

    # set reply message
    message = { type: 'text', text: '好～喵嗚～' }

    # send message
    client.reply_message(reply_token, message)

    # respond 200
    head :ok
  end
end
