class QuartersController < ApplicationController
  before_filter :authorize, except: [:index, :show]
  
  def index
    @quarters = Quarter.all
  end
  
  def show
    @quarter = Quarter.find(params[:id])
  end
  
  def new
    @quarter = Quarter.new
  end
  
  def create
    
  end
  
  def edit
    @quarter = Quarter.find(params[:id])
  end
  
  def update
    
  end
  
  def destroy
    Quarter.find(params[:id]).destroy
  end
  
  
  private
  
  def quarter_params
    params.require(:quarter).permit(:name, :short_name)
  end
end
