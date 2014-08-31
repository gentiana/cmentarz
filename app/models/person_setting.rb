class PersonSetting
  attr_reader :person, :person_params, :birth_params, :death_params
  
  def initialize(person, person_params, birth_params, death_params)
    @person = person
    @person_params = person_params
    @birth_params = birth_params.values.any?(&:present?) ? birth_params : nil
    @death_params = death_params.values.any?(&:present?) ? death_params : nil
  end
  
  def update
    Person.transaction do
      # try to update all records to force all validations
      # and detect all errors 
      birth_success = set_birth_date
      death_success = set_death_date
      person_success = update_person
      
      if birth_success && death_success && person_success
        @person
      else
        raise ActiveRecord::Rollback
      end
    end
  end
  
  
  private
  
  # returned value should be logically true if and only if params are correct
  def set_birth_date
    if @person.birth_date
      @person.birth_date.set(@birth_params)
    else
      !@birth_params || @person.create_birth_date(@birth_params).persisted?
    end
  end
  
  # returned value should be logically true if and only if params are correct
  def set_death_date
    if @person.death_date
      @person.death_date.set(@death_params)
    else
      !@death_params || @person.create_death_date(@death_params).persisted?
    end
  end
  
  def update_person
    @person.update(@person_params)
  end
end
