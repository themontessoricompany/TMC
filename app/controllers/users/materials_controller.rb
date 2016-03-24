class Users::MaterialsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    authorize! :show, @user
    @products = @user.purchased_products
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end