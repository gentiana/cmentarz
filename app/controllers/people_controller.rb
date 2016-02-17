class PeopleController < ApplicationController
  before_action :authorize, except: [:index, :show, :search]

  def index
    @people = Person.any_info.paginate(page: params[:page])
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new
    setting = PersonSetting.new(@person, person_params, birth_params, death_params)
    if setting.create
      redirect_to @person, notice: create_notice(:person)
    else
      render :new
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    setting = PersonSetting.new(@person, person_params, birth_params, death_params)
    if setting.update
      redirect_to @person, notice: update_notice(:person)
    else
      render :edit
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    redirect_to people_path, notice: destroy_notice(:person)
  end

  def search
    @people = Person.search(params[:search])
    render json: @people
  end

  private

  def person_params
    params.require(:person).permit(
      :first_name, :last_name, :family_name, :lived, :raw_record,
      { data_state: [] }, :description, :notes, :grave_id
    )
  end

  def birth_params
    params.require(:person).require(:birth_date).permit(:year, :month, :day)
  end

  def death_params
    params.require(:person).require(:death_date).permit(:year, :month, :day)
  end
end
