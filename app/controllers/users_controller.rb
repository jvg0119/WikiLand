class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your name was updated successfully!"
      redirect_to :back # stay in this page
    else
      flash[:error] = "There was an error updating your name. Please try again."
      render :edit
    end
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end

end
