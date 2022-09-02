require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant[:attributes]).to_not have_key(:created_at)
      expect(merchant[:attributes]).to_not have_key(:updated_at)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq(id.to_s)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)

    expect(merchant[:data][:attributes]).to_not have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not have_key(:updated_at)
  end

  it "finds one merchant's items" do
    merchant = create(:merchant)
    items = create_list(:item, 10, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(items.count).to eq(10)

    items.each do |item|
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

  it "returns 404 if merchant not found" do
    get "/api/v1/merchants/1234567/items"
    expect(response.status).to eq(404)

    get "/api/v1/merchants/1234567"
    expect(response.status).to eq(404)
  end

  it "will return a single result if found" do
    merchant1 = Merchant.create!(name: "Friday", created_at: Time.now, updated_at: Time.now)
    merchant2 = Merchant.create!(name: "Ring World", created_at: Time.now, updated_at: Time.now)

    get "/api/v1/merchants/find?name=ring"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants[:attributes]).to have_key(:name)
    expect(merchants[:attributes][:name]).to eq("Ring World")
    end
  end
