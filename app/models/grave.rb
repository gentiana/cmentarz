class Grave < ActiveRecord::Base
  include DataState
  
  has_many :people
  belongs_to :quarter
  validates :number, presence: true, uniqueness: {scope: :quarter_id}
  
  enum grave_type: {single: 0, family: 1}
  
  # it shouldn't be callback, user should be able to set grave type as he wants
  def set_grave_type!
    if people.count > 1
      family!
    else
      single!
    end
  end
end
