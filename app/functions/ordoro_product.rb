class OrdoroProduct
  
    def self.rm_eta_from_title(product_sku)
      puts "rm_eta_from_title: #{product_sku}"
      product = get_product(product_sku)

      if product
        name = product["name"]
        pattern = /~\s*~.*~\s*~\s*/

        if name.match(pattern)
          cleaned_name = product["name"].gsub(pattern, '')
          set_product_name(product_sku, cleaned_name)
        end
      end
    end
  
    private
      def self.get_product(product_sku)
        puts "get Ordoro product: #{product_sku}"
        url = URI("https://api.ordoro.com/product/#{product_sku}/")
        product = http_request(url, nil, 'get')
        return product
      end
      
      def self.set_product_name(product_sku, name)
        puts "set Ordoro product name: #{product_sku} => #{name}"
        url = URI("https://api.ordoro.com/product/#{product_sku}/")
        http_request(url, {"name" => name}, 'put')    
      end
  
      def self.http_request(url, body = nil, type = nil)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
        if type == "delete"
          request = Net::HTTP::Delete.new(url)
        elsif type == "post"
          request = Net::HTTP::Post.new(url)
        elsif type == "put"
          request = Net::HTTP::Put.new(url)
        elsif type == "get"
          request = Net::HTTP::Get.new(url)
        else
          request = Net::HTTP::Get.new(url)
        end

        request["content-type"] = 'application/json'
        request["Access-Control-Allow-Headers"] = 'application/json'

        # Set Basic Authentication credentials (username and password)
        username = ENV['ORDORO_USER']
        password = ENV['ORDORO_PASS']
        request.basic_auth(username, password)
  
        if body
          request.body = body.to_json
        end

        # puts Colorize.yellow(url)
  
        response = http.request(request)

        response.read_body

        if response.code == '200'
          puts Colorize.green(response.code)
          data = JSON.parse(response.body)
          return data
        else
          puts Colorize.red(response.body)
          puts Colorize.red(response.code)
        end
      end
  
  end