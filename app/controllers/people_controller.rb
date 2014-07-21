class PeopleController < ApplicationController
  before_filter :authorize, except: [:index, :show]
  
  def index
    @people = Person.paginate(page: params[:page])
  end
  
  def show
    @person = Person.find(params[:id])
  end
  
  def new
    @person = Person.new
  end
  
  def create
    
  end
  
  def edit
    @person = Person.find(params[:id])
  end
  
  def update
    
  end
  
  def destroy
    Person.find(params[:id]).destroy
  end
  
  private
  def person_params
    params.require(:person).permit(:first_name, :last_name, :family_name,
                                   :data_state, :description)
  end
end
