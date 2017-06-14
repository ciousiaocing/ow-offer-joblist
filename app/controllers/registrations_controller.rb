class RegistrationsController < ApplicationController

  private

  def sign_up_params
    params.require(:user).permit(:is_admin, :is_candidate, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:is_admin, :is_candidate, :email, :password, :password_confirmation, :current_password)
  end
end
