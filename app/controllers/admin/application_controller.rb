# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      redirect_to '/', alert: 'Not authorized.' unless is_current_user_admin?
    end

    private

    def is_current_user_admin?
      if current_user
        current_user.role == 'admin'
      else
        false
      end
    end
  end
end
