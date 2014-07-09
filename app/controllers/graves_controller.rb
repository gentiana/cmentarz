class GravesController < ApplicationController
  before_filter :authorize, except: [:index, :show]
  
  def index
    @quarters = Quarter.includes(:graves).select { |q| q.graves.any? }
  end
  
  def show
    @grave = Grave.find(params[:id])
  end
  
  def new
    @grave = Grave.new
  end
  
  def create
    
  end
  
  def edit
    @grave = Grave.find(params[:id])
  end
  
  def update
    
  end
  
  def destroy
    Grave.find(params[:id]).destroy
    flash[:success] = "Destroyed grave"
    redirect_to graves_path
  end
  
  
  private
  
  def grave_params
    params.require(:grave).permit(:number, :grave_type, :description,
                                  :family_name, :data_state, :notes)
  end
end
