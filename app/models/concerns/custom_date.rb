module CustomDate
  # Dates on graves aren't always complete - sometimes there is full date,
  # sometimes there is only year, or even year and month without day.
  
  extend ActiveSupport::Concern
  
  PL_MONTHS = %w(styczeń luty marzec kwiecień maj czerwiec lipiec sierpień
                 wrzesień październik listopad grudzień)
  
  included do
    # include Comparable  # uncomment to overload comparision operators
    belongs_to :person
    validates :person, presence: true
    validates :year, presence: true,
                     numericality: {greater_than_or_equal_to: 1000}
    validate :valid_date
  end
  
  # to validate that date of death isn't before date of birth
  # 1902 could be before 1902.04.06
  # 1902.04.06 could be before 1902
  # 1912 couldn't be before 1911.06
  def could_be_before(other)
   (self <=> other) <= 0     # (self <= other)
  end
  
  def to_s
    if month && !day
      "#{PL_MONTHS[month-1]} #{year}"
    else
      [year, month, day].compact.map { |i| i < 10 ? "0#{i}" : i }.join('.')   
    end
  end
  
  def valid_date
    errors[:base] << "Date is invalid" if day unless month
    y = year or return  # presence of year is already validated in another place
    m = month || 1
    d = day || 1
    begin
      date = Date.new(y, m, d)
      errors[:base] << "Can't be a future date" if date > Time.now
    rescue ArgumentError
      errors[:base] << "Date is invalid"
    end
  end
  
  def <=> (other)
    m1 = month
    d1 = day
    m2 = other.month
    d2 = other.day
    d1 = d2 = 1 unless d1 && d2
    m1 = m2 = 1 unless m1 && m2
    
    Date.new(year, m1, d1) <=> Date.new(other.year, m2, d2)
  end
end
