require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end

    it "returns 404 if item not found" do
      get "/api/v1/items/1234567"
      expect(response.status).to eq(404)

      get "/api/v1/items/whatever"
      expect(response.status).to eq(404)
    end

    it "can create items" do
    merchant = create(:merchant).id

    item_params = ({
      name: 'Keyboard',
      description: 'Good for typing',
      unit_price: 25.55,
      merchant_id: merchant
    })

    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    new_item = Item.last

    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  xit "can create items only with all required parameters" do
    merchant = create(:merchant).id

    item_params = ({
      name: 'Keyboard',
      description: 'Good for typing',
      merchant_id: merchant
      })

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to eq(404)
    end

    it "can edit items" do
    merchant = create(:merchant).id

    item_params = ({
      name: 'Keyboard',
      description: 'Good for typing',
      unit_price: 25.55,
      merchant_id: merchant
    })

    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    new_item = Item.last

    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])

    new_item_params = ({
      name: 'Monitor',
      description: 'Good for coding',
      unit_price: 155.25,
      merchant_id: merchant
    })

    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{new_item.id}", headers: headers, params: JSON.generate(item: new_item_params)

    updated_item = Item.last

    expect(updated_item.name).to eq(new_item_params[:name])
    expect(updated_item.description).to eq(new_item_params[:description])
    expect(updated_item.unit_price).to eq(new_item_params[:unit_price])
    expect(updated_item.merchant_id).to eq(new_item_params[:merchant_id])
  end

  it "can get an item's merchant" do
    merchant = create(:merchant)

    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    found_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(found_merchant.count).to eq(1)
    expect(found_merchant[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "returns 404 if item not found" do
    get "/api/v1/items/1234567/merchant"
    expect(response.status).to eq(404)
  end  
end
