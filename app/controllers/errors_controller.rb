class ErrorsController < ApplicationController
  respond_to :json, :js, :html
  before_action :set_status

  def show
    respond_with @status
  end

  private

  def set_status
    @exception  = env['action_dispatch.exception']
    @status  = ActionDispatch::ExceptionWrapper
      .new(env, @exception).status_code
  end
end
