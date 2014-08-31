module PeopleHelper
  def quarter_select_options
    {
      collection: Quarter.all,
      value_method: :id,
      selected: (@person.quarter.id if @person.quarter),
      include_blank: true
    }
  end
end
