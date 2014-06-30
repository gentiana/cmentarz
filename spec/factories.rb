FactoryGirl.define do
  factory :quarter do
    sequence(:name) { |i| "Kwatera #{i}" }
  end
  
  factory :grave do
    number '666'
    quarter
  end
  
  factory :person do
    first_name 'Alicja'
    last_name 'Grzybowska'
    family_name 'Piwowarczyk'
    
    association :grave
  end
  
  
  factory :date, class: BirthDate do
    day 29
    month 2
    year 2012
    association :person
    
    factory :invalid_date do
      year 2013
    end
    
    factory :future_date do
      t = Time.now + 5.days
      day t.day
      month t.month
      year t.year
    end
    
    factory :very_invalid_date do
      year '   '
      month 'cat'
      day [6, 6, 6]
    end
  end
  
  factory :just_year, class: BirthDate do
    year 1000
    association :person
    
    factory :invalid_year do
      year 999
    end
    
    factory :future_year do
      year(Time.now.year + 1)
    end
    
    factory :future_month do
      year(Time.now.year)
      month(Time.now.month + 1)
    end
    
    factory :without_day do
      month 12
    end
    
    factory :invalid_month do
      month 13
    end
    
    factory :without_month do
      day 6
    end
  end
end