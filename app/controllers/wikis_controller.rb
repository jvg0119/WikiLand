class WikisController < ApplicationController
  require 'will_paginate/array'
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]

  def index
    #@wikis = Wiki.all
    #authorize @wikis

    @wikis = policy_scope(Wiki).paginate(page: params[:page], per_page: 10)
    @public_wikis = Wiki.public_wikis.paginate(page: params[:page], per_page: 10)
    #
    if current_user && current_user.admin?
      @private_wikis = Wiki.private_wikis_admin.paginate(page: params[:page], per_page: 10)
    else
      @private_wikis = ((Wiki.private_wikis(current_user) + current_user.wiki_collaborations)).paginate(page: params[:page], per_page: 10) if current_user#.paginate(page: params[:page], per_page: 10) #if current_user
    end
  end

  def show
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki
    #byebug
    if @wiki.save
      flash[:success] = "Your wiki was saved successfully!"
      redirect_to(@wiki)
    else
      flash[:error] = "Your wiki was not saved. Please try again."
      render :new
    end
  end

  def edit
    authorize @wiki
  end

  def update
    authorize @wiki
    if @wiki.update_attributes(wiki_params)
      flash[:success] = "Your wiki was updated successfully!"
      redirect_to(@wiki)
    else
      flash[:error] = "Your wiki was not updated. Please try again."
      render :edit
    end
  end

  def destroy
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = "Your wiki was deleted."
      redirect_to wikis_url
    end
  end

  private
  def set_wiki
    @wiki = Wiki.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
