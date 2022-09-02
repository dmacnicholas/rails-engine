class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.find_all_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end
end
