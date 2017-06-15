class CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki

  def new
    #@wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new
    authorize @collaborator
    #@users = @wiki.wiki_collaborators  # these are users for this wiki only (not all users)
    @users = User.all
    #raise
  end

  def create
    #@wiki = Wiki.find(params[:wiki_id])
    @user = User.find(params[:user])
    @collaborator = Collaborator.new(wiki: @wiki, user: @user)
    authorize @collaborator
    if @collaborator.save
      flash[:notice] = "You are now a collaborator for #{@wiki.title}."
      redirect_to :back
      #raise
    end
  end

  def destroy
      #@wiki = Wiki.find(params[:wiki_id])
      #@user = User.find(params[:id])
      #@collaborator = @wiki.collaborators.find_by(user_id: @user.id)
      @collaborator = @wiki.collaborators.find_by(user_id: params[:id])
      authorize @collaborator
      #raise
      if @collaborator.destroy
        flash[:notice] = "You are not a collaborator for this wiki anymore."
        redirect_to :back
      end
  end

  private
  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end

end
