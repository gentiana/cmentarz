class GravesController < ApplicationController
  before_filter :authorize, except: [:index, :show]
  
  def index
    @quarters = Quarter.includes(:graves).select { |q| q.graves.any? }
    @quarters = Quarter.sort_by_name(@quarters)
  end
  
  def show
    @grave = Grave.find(params[:id])
  end
  
  def new
    @grave = Grave.new
  end
  
  def create
    @grave = Grave.new(grave_params)
    if @grave.save
      redirect_to @grave, notice: create_notice(:grave)
    else
      render :new
    end
  end
  
  def edit
    @grave = Grave.find(params[:id])
  end
  
  def update
    @grave = Grave.find(params[:id])
    if @grave.update(grave_params)
      redirect_to @grave, notice: update_notice(:grave)
    else
      render :edit
    end
  end
  
  def destroy
    Grave.find(params[:id]).destroy
    redirect_to graves_path, notice: destroy_notice(:grave)
  end
  
  
  private
  
  def grave_params
    params.require(:grave).permit(:quarter_id, :number, :description, :notes,
                                  :grave_type, :family_name, :data_state)
  end
end
