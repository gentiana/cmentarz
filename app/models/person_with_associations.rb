class PersonWithAssociations
  KEYS = [:first_name, :last_name, :family_name, :lived, :data_state, :notes,
          :raw_record, :quarter, :grave_nr, :grave_type, :birth_year,
          :birth_month, :birth_day, :death_year, :death_month, :death_day]
          
  attr_accessor :params   # for factory girl
  
  def initialize(params = nil)
    @params = params
  end
  
  def create!
    Person.transaction do
      set_quarter
      set_grave
      add_person
      add_birth_date
      add_death_date
    end
  end
  
  
  private
  
  def set_quarter
    @quarter = Quarter.find_by!(short_name: @params[:quarter])
  rescue
    @quarter = Quarter.create_from_short_name!(@params[:quarter])
  end
  
  def set_grave
    @grave = @quarter.graves.find_or_create_by!(number: @params[:grave_nr])
  end
  
  def add_person
    person_params = @params.select { |k, v| Person.attribute_method? k }
    @person= @grave.people.create!(person_params)
  end
  
  def add_birth_date
    if @params[:birth_year].present?
      @person.create_birth_date!(year: @params[:birth_year],
                                 month: @params[:birth_month],
                                 day: @params[:birth_day])
    end
  end
  
  def add_death_date
    if @params[:death_year].present?
      @person.create_death_date!(year: @params[:death_year],
                                 month: @params[:death_month],
                                 day: @params[:death_day])
    end
  end
end
