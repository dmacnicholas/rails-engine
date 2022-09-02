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

  # xit "can create items only with all required parameters" do
  #   merchant = create(:merchant).id
  #
  #   item_params = ({
  #     name: 'Keyboard',
  #     description: 'Good for typing',
  #     merchant_id: merchant
  #     })
  #
  #     headers = {"CONTENT_TYPE" => "application/json"}
  #     post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
  #
  #     expect(response).to eq(404)
  #   end

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

  it "can delete an item" do
    merchant = create(:merchant)

    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)

    delete "/api/v1/items/#{item_1.id}"

    expect(response).to be_successful

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(1)

    items.each do |item|
      expect(item[:attributes][:name]).to_not eq(item_1[:name])
      expect(item[:attributes][:name]).to eq(item_2[:name])
    end
  end

  it "deletes the invoice if deleted item was the only item on the invoice" do
    merchant = create(:merchant)
    customer = Customer.create!(first_name: "John", last_name: "Smith")

    invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
    item_1 = create(:item, merchant_id: merchant.id)
    invoice_item = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id)

    expect(invoice.items.count).to eq(1)

    delete "/api/v1/items/#{item_1.id}"

    expect(Invoice.exists?(invoice.id)).to be false
  end

  it "will return all items with a match to the search" do
    merchant = Merchant.create!(name: "Turing", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Watch", description: "Nice", unit_price: 30, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Jump Rope", description: "Fun", unit_price: 10, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Tree", description: "Big", unit_price: 70, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)

    get "/api/v1/items/find_all?name=atch"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq("Watch")
    end
  end

  end
