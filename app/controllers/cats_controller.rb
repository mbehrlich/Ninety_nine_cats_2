class CatsController < ApplicationController

  before_action :cat_owner_check, only: [:edit, :update]
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @rental_requests = @cat.rental_requests.includes(:requester)
    @admin_user = current_user.cats.include?(@cat)
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def cat_owner_check
    if current_user.nil?
      flash[:errors] ||= []
      flash[:errors] << "Please log in for editing cats."
      redirect_to cats_url
    else
      @cat = current_user.cats.find_by(id: params[:id])
      if @cat.nil?
        flash[:errors] ||= []
        flash[:errors] << "It's not your cat!"
        redirect_to cats_url
      end
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
