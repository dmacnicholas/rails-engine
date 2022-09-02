require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:merchant) }
  it { should have_many(:invoice_items) }
  it { should have_many(:invoices).through(:invoice_items) }

  it "will return all items with a match to the search" do
    merchant = Merchant.create!(name: "Turing", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Watch", description: "Nice", unit_price: 30, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Jump Rope", description: "Fun", unit_price: 10, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Tree", description: "Big", unit_price: 70, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)
    item4 = Item.create!(name: "Matches", description: "Fire", unit_price: 80, merchant_id: merchant.id, created_at: Time.now, updated_at: Time.now)

    items = Item.find_all_by_name("atch")

    expect(items.count).to eq(2)

    expect(items[0][:name]).to eq("Watch")
    expect(items[1][:name]).to eq("Matches")
  end
end
