class NekocatController < ApplicationController
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
    render plain: "虎挖花哈哈哈"
    puts "===這是設定後的response.body:#{response.body}==="
  end

  def webhook
    head :ok
  end
end