class AdminSettingsController < ApplicationController
  def edit
    @admin_setting = AdminSetting.first
    authorize! :edit, @admin_setting
  end

  def update
    @admin_setting = AdminSetting.first
    authorize! :update, @admin_setting
    if @admin_setting.update_attributes(admin_setting_params)
      flash[:notice] = "Settings have been updated."
      redirect_to root_path and return
    else
      render action: :edit
    end
  end

  protected

  def admin_setting_params
    params.require(:admin_setting).permit!
  end

end
