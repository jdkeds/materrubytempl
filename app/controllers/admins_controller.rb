class AdminsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :admin, class: 'User'

  def new
    if current_user.has_role?(:sysadmin) || current_user.has_role?(:superadmin)
      @admin.add_role :admin
    else
      redirect_to authenticated_root_url, alert: 'You are not authorized to access this page.'
    end
  end

  def create
    if current_user.has_role?(:sysadmin) || current_user.has_role?(:superadmin)
      @admin.id = nil
      respond_to do |format|
        if @admin.save
          @admin.add_role :admin
          format.html { redirect_to @admin, notice: 'Administator was successfully created.' }
        else
          format.html { render action: 'new' }
        end
      end
    else
      redirect_to authenticated_root_url, alert: 'You CANNOT create an admin.'
    end
  end

  private

  def admin_params
    params.require(:user).permit(:email, :password)
  end

end
