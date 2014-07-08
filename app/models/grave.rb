class Grave < ActiveRecord::Base
  include DataState
  include Comparable
  
  has_many :people
  belongs_to :quarter
  validates :number, presence: true, uniqueness: {scope: :quarter_id}
  validate :nonnegative_number
  
  enum grave_type: {single: 0, family: 1}
  
  # it shouldn't be callback, user should be able to set grave type as he wants
  def set_grave_type!
    if people.count > 1
      family!
    else
      single!
    end
  end
  
  def <=> (other)
    if quarter_id == other.quarter_id
      # graves where 'number' is a name like "Tomb of the Unknown Soldier"
      # should be listed first - to_int returns -1
      if is_int?(number) || is_int?(other.number)
        to_int(number) <=> to_int(other.number)
      else
        number <=> other.number
      end
    else
      quarter_id <=> other.quarter_id
    end
  end
  
  def name
    is_int?(number) ? "Grób nr #{number}" : number
  end
  
  
  private
  
  def is_int?(str)
    Integer(str) rescue false
  end
  
  def to_int(str)
    Integer(str) rescue -1
  end
  
  def nonnegative_number
    if is_int?(number) && number.to_i < 0
      errors[:number] << "can't be negative"
    end
  end
end
