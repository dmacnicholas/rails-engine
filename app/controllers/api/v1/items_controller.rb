class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  def create
    merchant = Merchant.find(params[:item][:merchant_id])
    item = merchant.items.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render status: 404
    end
  end


  private

  def item_params
    params[:item].permit(:name, :description, :unit_price, :merchant_id)
  end
end
