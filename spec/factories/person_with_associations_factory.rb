FactoryGirl.define do
  factory :pwa, class: PersonWithAssociations do
    skip_create
    
    params {{:first_name=>"Jakub", :last_name=>"Kieszka", :family_name=>nil, :lived=>nil,
             :raw_record=>"Kieszka Jakub | 17.02.1858-28.12.1931 | k.1/069gr",
             :data_state=>"auto", :notes=>nil, :grave_nr=>"69", :quarter=>"k1",
             :grave_type=>"family", :birth_year=>"1858", :birth_month=>"02",
             :birth_day=>"17", :death_year=>"1931", :death_month=>"12", :death_day=>"28"}}
    
    factory :pwa_invalid do
      params {{:first_name=>"Franciszka", :last_name=>"Ciaputa", :family_name=>"",
               :lived=>"", :data_state=>"auto", :notes=>"",
               :raw_record=>"Ciaputa Franciszka | 1899-2970 | k.2/026gr",
               :quarter=>"k2", :grave_nr=>"26", :grave_type=>"family", :birth_year=>"1899",
               :birth_month=>"", :birth_day=>"", :death_year=>"2970", :death_month=>nil, :death_day=>nil}}
    end
    
    factory :pwa_without_dates do
      params {{:first_name=>nil, :last_name=>nil, :family_name=>nil, :lived=>nil,
               :raw_record=>"Nieznane | Nieznane | k.1/005gr", :data_state=>"auto",
               :notes=>nil, :grave_nr=>"5", :quarter=>"k1", :grave_type=>"family",
               :birth_year=>"", :birth_month=>nil, :birth_day=>nil,
               :death_year=>nil, :death_month=>nil, :death_day=>nil}}
    end
  end
end
