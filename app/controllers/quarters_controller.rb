class QuartersController < ApplicationController
  before_filter :authorize, except: [:index, :show]
  
  def index
    @quarters = Quarter.all
  end
  
  def show
    @quarter = Quarter.find(params[:id])
    @graves = @quarter.graves
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
    @quarter = Quarter.find(params[:id])
    if @quarter.update(quarter_params)
      redirect_to @quarter, notice: update_notice(:quarter)
    else
      render :edit
    end
  end
  
  def destroy
    Quarter.find(params[:id]).destroy
    redirect_to quarters_path, notice: destroy_notice(:quarter)
  end
  
  
  private
  
  def quarter_params
    params.require(:quarter).permit(:name, :short_name)
  end
end
