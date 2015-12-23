class PersonSetting
  attr_reader :person, :person_params, :birth_params, :death_params

  def initialize(person, person_params, birth_params, death_params)
    @person = person
    @person_params =
      person_params.merge(person_params) { |_k, v| v.present? ? v : nil }
    @birth_params = birth_params.values.any?(&:present?) ? birth_params : nil
    @death_params = death_params.values.any?(&:present?) ? death_params : nil
  end

  def create
    set_person do
      # try to create all records to force all validations
      # and detect all errors
      birth_success = add_birth_date
      death_success = add_death_date
      person_success = update_person

      birth_success && death_success && person_success
    end
  end

  def update
    set_person do
      # try to update all records to force all validations
      # and detect all errors
      birth_success = set_birth_date
      death_success = set_death_date
      person_success = update_person

      birth_success && death_success && person_success
    end
  end

  private

  def set_person
    Person.transaction do
      if yield
        @person
      else
        fail ActiveRecord::Rollback
      end
    end
  end

  # returned value should be logically true if and only if params are correct
  def set_birth_date
    if @person.birth_date
      @person.birth_date.set(@birth_params)
    else
      add_birth_date
    end
  end

  # returned value should be logically true if and only if params are correct
  def set_death_date
    if @person.death_date
      @person.death_date.set(@death_params)
    else
      add_death_date
    end
  end

  def add_birth_date
    !@birth_params || @person.create_birth_date(@birth_params).persisted?
  end

  def add_death_date
    !@death_params || @person.create_death_date(@death_params).persisted?
  end

  def update_person
    @person.update(@person_params)
  end
end
