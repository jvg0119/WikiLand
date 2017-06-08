class ChargesController < ApplicationController
  before_action :authenticate_user! # make sure user is signed in before charging; need user to charge
  before_action :set_amount
  before_action :set_description

  def create
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id,  # Note -- this is NOT the user_id in your app
      amount: @amount,
      description: @description,   #{}"Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    # upgrade to premium
    current_user.premium!
    #current_user.wikis.where(private: true) 
    flash[:notice] = "Thanks for upgrading to #{@description} - #{current_user.email}"
    redirect_to root_url #user_path(current_user)
    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.

  rescue Stripe::CardErrors => e
    flash[:alert] = e.message
    redirect_to new_charge_path
  end # create

  #
  # def new
  #   @stripe_btn_data = {
  #     key: "#{Rails.configuration.stripe[:publishable_key]}",
  #     amount: @amount,
  #     description: @description
  #   }
  # end

  def new
  end

  def downgrade
    current_user.standard!
    flash[:notice] = "You are now downgraded to statndard user - #{current_user.email}"
    redirect_to root_url
  end

private
  def set_amount
    @amount = 1500 # in pennies = $15
  end

  def set_description
    @description = "Blocipedia Premium Account Membership"
  end

end
