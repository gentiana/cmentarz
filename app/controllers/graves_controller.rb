class GravesController < ApplicationController
  before_action :set_grave, only: [:show, :edit]
  
  def index
    @graves = Grave.paginate(page: params[:page])
  end
  
  def show
  end
  
  def new
    @grave = Grave.new
  end
  
  def create
    
  end
  
  def edit
  end
  
  def update
    
  end
  
  def destroy
    Grave.find(params[:id]).destroy
  end
  
  private
  def set_grave
    @grave = Grave.find(params[:id])
  end
  
  def grave_params
    params.require(:grave).permit(:number, :type, :row, :description, :family_name,
                                  :data_state, :notes)
  end
end
