class Grave < ActiveRecord::Base
  include DataState
  
  has_many :people
  belongs_to :quarter
  validates :number, presence: true, uniqueness: {scope: :quarter_id}
  
  enum type: {single: 0, family: 1}
end
