class CartData

  def self.send_email(params)
    CartMailer.save_cart_email(params).deliver
  end

  def self.send_to_omnisend
    puts "test again"
    url = URI('https://api.omnisend.com/v3/contacts')
    contact_data = {"email" => 'email@example2.com', "status" => "unsubscribed", "statusDate" => Time.now}
    http_request url, contact_data, 'post'
  end

  private

    def self.http_request(url, body = nil, type = nil)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      if type == "delete"
        request = Net::HTTP::Delete.new(url)
      elsif type == "post"
        request = Net::HTTP::Post.new(url)
      elsif type == "get"
        request = Net::HTTP::Get.new(url)
      else
        request = Net::HTTP::Get.new(url)
      end

      puts ENV['OMNISEND_API_KEY']

      request["X-API-KEY"] = ENV['OMNISEND_API_KEY']
      request["content-type"] = 'application/json'

      if body
        request.body = body.to_json
      end

      response = http.request(request)

      puts Colorize.yellow(request.body)
      puts Colorize.yellow(response.code)

      response.read_body
    end

end