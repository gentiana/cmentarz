FactoryGirl.define do
  factory :quarter do
    sequence(:name) { |i| "Kwatera #{i}" }
    sequence(:short_name) { |i| "k#{i}" }
    
    factory :updated_quarter do
      name "Pas 555"
      short_name "p555"
    end
  end
  
  factory :grave do
    sequence(:number) { |i| i.to_s }
    grave_type 'single'
    description 'lorem ipsum'
    family_name 'Milanowicz'
    notes 'zażółć gęślą jaźń'
    
    quarter
    
    factory :updated_grave do
      number '777'
      description 'qwerty asdf'
      family_name 'Sikora'
      notes 'qui dolorem ipsum, quia dolor sit'
    end
  end
  
  factory :quarterless_grave, class: Grave do
    sequence(:number) { |i| 1234 + i }
  end
  
  factory :person do
    first_name 'Alicja'
    last_name 'Grzybowska'
    family_name 'Piwowarczyk'
    description 'lorem ipsum'
    lived 67
    raw_record 'qwerty | asdf | 826538'
    notes 'zażółć gęślą jaźń'
    
    association :grave
    
    factory :updated_person do
      first_name 'Elżbieta'
      last_name 'Nowak'
      family_name 'Kowalska'
      description 'qwerty'
      lived 34
      raw_record 'jjdsioa gore fj dsfiud saufisa'
      notes 'isojfa ajorea hiuas'
    end
  end
  
  factory :empty_person, class: Person do
    association :grave
    
    factory :only_notes do
      notes 'bla bla'
    end
    
    factory :only_description do
      description 'qwerty'
    end
  end
end
