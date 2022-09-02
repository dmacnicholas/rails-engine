FactoryBot.define do
  factory :invoice do
    customer_id { 1 }
    status { "shipped" }
  end
end
