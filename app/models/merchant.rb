class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name

  def self.find_one_by_name(name)
    where("name ILIKE ?", "%#{name}%").order(:name).first
  end
end
