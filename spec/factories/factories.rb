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
end
