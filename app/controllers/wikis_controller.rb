class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
#  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @wikis = Wiki.all
  end

  def show
  end

  def new
    @wiki = Wiki.new
  end
# no flash messges
  def create
    #byebug
    @wiki = Wiki.new(wiki_params)
    #byebug
    @wiki.user = current_user
    #byebug
    if @wiki.save
      flash[:notice] = "Your wiki was saved successfully!"
      redirect_to(@wiki)
    else
      flash[:error] = "Your wiki was not saved. Please try again."
      render :new


    #  byebug
    end
  end

  def edit
  end

  def update
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Your wiki was updated successfully!"
      redirect_to(@wiki)
    else
      flash[:error] = "Your wiki was not updated. Please try again."
      render :edit
    end
  end

  def destroy
    if @wiki.destroy
      redirect_to wikis_url
      #byebug
    end
  end

  private
  def set_wiki
    @wiki = Wiki.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end

end
