require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
  end

  describe 'validations' do
   it { should validate_presence_of :name }
 end

  it "will return a single result if found" do
     merchant1 = Merchant.create!(name: "Friday", created_at: Time.now, updated_at: Time.now)
     merchant2 = Merchant.create!(name: "Ring World", created_at: Time.now, updated_at: Time.now)

     merchant = Merchant.find_one_by_name("ring")

     expect(merchant[:name]).to eq("Ring World")
   end

   it "will return the first result in case-insensitive alpabetical order" do
     merchant1 = Merchant.create!(name: "Turing", created_at: Time.now, updated_at: Time.now)
     merchant2 = Merchant.create!(name: "Ring World", created_at: Time.now, updated_at: Time.now)
     merchant2 = Merchant.create!(name: "A Ringer", created_at: Time.now, updated_at: Time.now)

     merchant = Merchant.find_one_by_name("ring")

     expect(merchant[:name]).to eq("A Ringer")
   end
end
