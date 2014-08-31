class PersonSettingFactory
  def empty_birth_params
    PersonSetting.new(person, person_params, empty_date, date)
  end
  
  def delete_birth_date
    PersonSetting.new(person_with_birth_date, person_params, empty_date, date)
  end
  
  def update_birth_date
    PersonSetting.new(person_with_birth_date, person_params, date, empty_date)
  end
  
  def everything_wrong
    PersonSetting.new(person, all_wrong_person_params, wrong_date, wrong_date_params)
  end
  
  
  private
  
  def person
    FactoryGirl.create(:person)
  end
  
  def person_with_birth_date
    FactoryGirl.create(:person, birth_date: FactoryGirl.create(:date))
  end
  
  def person_params
    { first_name: "Ala" }
  end
  
  def all_wrong_person_params
    { lived: 'd3' }
  end
  
  def date
    { year: "1978", month: "3", day: "14" }
  end
  
  def earlier_date
    { year: "1878", month: "3", day: "14" }
  end
  
  def wrong_date
    { year: "1878", month: "2", day: "30" }
  end
  
  def wrong_date_params
    { year: "999", month: "13", day: "kot" }
  end
  
  def empty_date
    { year: "", month: "", day: "" }
  end
end