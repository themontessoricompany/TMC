class InterestsController < ApplicationController
  before_action :set_interest, only: [:show, :add_user_interest]
  before_action :set_user, only: [:add_user_interest]

  def show
    store_location_for(:user, interest_path(@interest))
    @users = @interest.users.opted_in_to_public_directory
    @comments = @interest.comments
      .order(created_at: :desc)
      .page(params[:page] || 1)
      .per(15)
    respond_to do |format|
      format.html
      format.json do
        render json: @interest, root: 'interest',
          each_serializer: InterestSerializer, comments: @comments
      end
    end
  end

  def add_user_interest
    authenticate_user!
    unless @interest.public
      redirect_to :back, alert: t('.private_interest')
      return
    end
    if @user.interests.include?(@interest)
      redirect_to :back, alert: t('.interest_already_added')
      return
    end
    if current_user != @user
      redirect_to :back, alert: t('.interest_can_be_added_only_to_your_account')
      return
    end
    @user.interests << @interest
    @user.save
    redirect_to :back, notice: t('.interest_added')
  end

  private

  def set_interest
    @interest = Interest.find(params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

end
