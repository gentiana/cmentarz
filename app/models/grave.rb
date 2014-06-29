class Grave < ActiveRecord::Base
  has_many :people
  belongs_to :quarter
  validates :number, presence: true
end
