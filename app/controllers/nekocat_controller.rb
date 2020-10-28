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
    render plain: params
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