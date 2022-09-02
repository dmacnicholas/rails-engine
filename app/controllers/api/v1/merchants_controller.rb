class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render status: 404
    end
  end

  def find_one_merchant
    merchant = Merchant.find_one_by_name(params[:name])
      if merchant == nil
        render json: { data: {} }
      else
        render json: MerchantSerializer.new(merchant)
      end
  end
end
