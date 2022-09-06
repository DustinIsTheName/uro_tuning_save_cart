class CartController < ApplicationController
  skip_before_action :verify_authenticity_token

  def save
    headers['Access-Control-Allow-Origin'] = '*'

    puts params

    CartData.send_email(params)
    # CartData.send_to_omnisend(params["email"])

    render json: params
  end

  def unsubscribe
    json = JSON.parse(request.raw_post)

    puts params["email"]
    if params["email"]
      CartData.unsubscribe_from_omnisend(params["email"])
    end
  end

  def bounce
    json = JSON.parse(request.raw_post)

    logger.info "json: #{json}"

    aws_needs_url_confirmed = json['SubscribeURL']

    if aws_needs_url_confirmed
      logger.info "AWS is requesting confirmation of the bounce handler URL"
      uri = URI.parse(aws_needs_url_confirmed)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get(uri.request_uri)
    else
      json['bounce']['bouncedRecipients'].each do |recipient|
        logger.info "AWS SES received a bounce on an email send attempt to #{recipient['emailAddress']}"
        CartData.unsubscribe_from_omnisend(recipient['emailAddress'])
      end
    end

    render nothing: true, status: 200
  end

  def complaint
    json = JSON.parse(request.raw_post)

    logger.info "json: #{json}"

    aws_needs_url_confirmed = json['SubscribeURL']

    if aws_needs_url_confirmed
      logger.info "AWS is requesting confirmation of the complaint handler URL"
      uri = URI.parse(aws_needs_url_confirmed)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get(uri.request_uri)
    else
      json['complaint']['complainedRecipients'].each do |recipient|
        logger.info "AWS SES received a complaint on an email send attempt to #{recipient['emailAddress']}"
        CartData.unsubscribe_from_omnisend(recipient['emailAddress'])
      end
    end
    
    render nothing: true, status: 200
  end

  def home
  end

end
