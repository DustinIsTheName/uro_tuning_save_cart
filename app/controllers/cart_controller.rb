class CartController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def save
    headers['Access-Control-Allow-Origin'] = '*'

    puts params

    CartData.send_email(params)
    CartData.send_to_omnisend

    render json: params
  end

end
