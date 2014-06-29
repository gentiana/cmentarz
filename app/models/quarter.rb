class Quarter < ActiveRecord::Base
  has_many :graves
  validates :name, presence: true
end
