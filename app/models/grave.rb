class Grave < ActiveRecord::Base
  include DataState
  include Comparable

  has_many :people, dependent: :destroy
  belongs_to :quarter
  validates :number, presence: true, uniqueness: { scope: :quarter_id }
  validate :nonnegative_number

  enum grave_type: { single: 0, family: 1 }

  scope :quarterless, -> { where quarter: nil }

  def self.names(quarter_id)
    graves =
      if quarter_id.present?
        where(quarter_id: quarter_id).sort
      else
        quarterless.sort
      end
    graves.map { |g| { id: g.id, name: g.name } }
  end

  # it shouldn't be callback, user should be able to set grave type as he wants
  def set_grave_type!
    if people.count > 1
      family!
    else
      single!
    end
  end

  def <=>(other)
    if quarter_id == other.quarter_id
      # graves where 'number' is a name like "Tomb of the Unknown Soldier"
      # should be listed first - to_int returns -1
      if int?(number) || int?(other.number)
        to_int(number) <=> to_int(other.number)
      else
        number <=> other.number
      end
    else
      quarter_id <=> other.quarter_id
    end
  end

  def name
    int?(number) ? "Grób nr #{number}" : number
  end

  private

  def int?(str)
    Integer(str)
  rescue
    false
  end

  def to_int(str)
    Integer(str)
  rescue
    -1
  end

  def nonnegative_number
    errors[:number] << "can't be negative" if int?(number) && number.to_i < 0
  end
end
