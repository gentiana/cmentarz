class Person < ActiveRecord::Base
  include DataState
  
  belongs_to :grave
  validates :grave, presence: true
  validates :lived, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  has_one :birth_date, dependent: :destroy
  has_one :death_date, dependent: :destroy
  validate :birth_before_death
  
  def full_name
    [first_name, last_name, family_name_in_parenthesis].compact.join(' ')
  end
  

  private
  
  def family_name_in_parenthesis
    "(#{family_name})" if family_name.present?
  end
  
  def birth_before_death
    if birth_date && death_date && !birth_date.could_be_before(death_date)
      errors[:base] << "A man must be born before he dies"
    end
  end
end
