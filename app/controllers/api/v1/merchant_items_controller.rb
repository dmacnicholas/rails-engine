class Api::V1::MerchantItemsController < ApplicationController

  def index
    if Merchant.exists?(params[:merchant_id])
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render status: 404
    end
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      merchant = Merchant.find(item.merchant_id)
      render json: MerchantSerializer.new(merchant)
    else
      render status: 404
    end
  end
end
